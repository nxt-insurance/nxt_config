require 'spec_helper'

RSpec.describe NxtConfig::Struct do
  let(:source_hash) do
    {
      flat_attribute: 'hello world',
      http: {
        headers: {
          user_agent: 'my cool app',
          api_key: 'secret123'
        }
      },
      mail: {
        sender: 'john.doe@example.org',
        server: 'smtp://example.org'
      },
      array_of_strings: %w[
        one
        two
        three
      ],
      array_of_hashes: [
        { key: 'value' }
      ]
    }
  end

  subject { described_class.new(source_hash) }

  describe 'key attribute accessor methods' do
    context 'when the attribute exists' do
      context 'and is flat' do
        it 'returns the attribute value' do
          expect(subject.flat_attribute).to eq 'hello world'
        end
      end

      context 'nesting' do
        it 'returns nested data as a struct' do
          expect(subject.http).to be_a NxtConfig::Struct
        end

        it 'returns the leave values when chained' do
          expect(subject.http.headers.user_agent).to eq 'my cool app'
        end
      end

      context 'and is an array' do
        it 'returns hash items as structs' do
          expect(subject.array_of_hashes).to be_an Array
          expect(subject.array_of_hashes.first).to be_a NxtConfig::Struct
          expect(subject.array_of_hashes.first.key).to eq 'value'
        end
      end
    end

    context 'when the attribute does not exist' do
      it 'raises an error' do
        expect { subject.unknown_attr }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#fetch' do
    context 'without arguments' do
      it 'raises an ArgumentError' do
        expect { subject.fetch }.to raise_error(ArgumentError, 'Provide at least one key')
      end
    end

    context 'with one key' do
      context 'that exists' do
        it 'returns the attribute value' do
          expect(subject.fetch(:flat_attribute)).to eq 'hello world'
          expect(subject.fetch('flat_attribute')).to eq 'hello world'
        end
      end

      context 'that does not exist' do
        it 'raises a KeyError' do
          expect { subject.fetch(:oh_no) }.to raise_error(KeyError)
          expect { subject.fetch('oh_no') }.to raise_error(KeyError)
        end
      end
    end

    context 'with more than one key' do
      context 'that exist' do
        it 'returns the attribute value' do
          expect(subject.fetch(:mail, :sender)).to eq 'john.doe@example.org'
          expect(subject.fetch('mail', 'sender')).to eq 'john.doe@example.org'
        end
      end

      context 'when one of the keys does not exist' do
        it 'raises a KeyError' do
          expect { subject.fetch(:mail, :postbox) }.to raise_error(KeyError)
        end
      end
    end

    context 'with a block' do
      context 'and the key does not exist' do
        let(:block) { Proc.new { :my_return_value } }

        it 'calls the block' do
          expect(subject.fetch(:oh_no, &block)).to eq :my_return_value
        end
      end
    end
  end
end
