require 'rails_helper'
require 'wizardry/graph'

describe Wizardry::Graph do
  describe '#to_dot' do
    subject { Wizardry::Graph.new(framework).to_dot.strip }

    context 'with a linear path' do
      include_context 'setup simple wizard'

      specify 'outputs a valid graphviz dot file' do
        expect(subject).to start_with("digraph name {")
        expect(subject).to end_with("}")
      end

      specify 'contains the right nodes and edges' do
        {
          'page_one'           => 'page_two',
          'page_two'           => 'page_three',
          'page_three'         => 'check_your_answers',
          'check_your_answers' => 'completion',
          'completion'         => 'finish',
        }.each do |left, right|
          expect(subject).to match("#{left} -> #{right};")
        end
      end
    end

    context 'with branching' do
      include_context 'setup branched wizard'

      specify 'contains labelled edges for met conditions' do
        expect(subject).to match(%r(page_two -> page_three \[label="Magic word\?"\];))
      end
    end
  end
end
