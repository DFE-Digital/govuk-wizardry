module Wizardry
  class Graph
    attr_reader :graph

    def initialize(framework)
      @framework = framework
      @graph     = reticulate
    end

    def to_dot
      <<~GRAPH
        digraph name {
          #{build_edges.flatten.join(";")};
        }
      GRAPH
    end

  private

    def reticulate
      @framework.pages.each.with_index.with_object({}) do |(current, i), g|
        # { current: { possible_next_page_1: condition } }
        g[current.name] = specified_next_pages(current).merge(following_page(current, i))
      end
    end

    def build_edges
      @graph.map do |source, targets|
        targets.map do |target_page, condition|
          %(#{source} -> #{target_page}).tap do |edge|
            if condition.present?
              formatted_condition = condition.source.match(/proc {.*}/).to_s.dump
              edge << %( [label=#{formatted_condition}])
            end
          end
        end
      end
    end

    def specified_next_pages(page)
      page.next_pages.each.with_object({}) do |np, h|
        h[np.name] = np.condition
      end
    end

    def following_page(page, index)
      next_non_branch_page = @framework.pages[index.next..].detect { |p| !p.branch? }

      if next_non_branch_page.present?
        { next_non_branch_page.name => nil }
      else
        { finish: nil }
      end
    end
  end
end
