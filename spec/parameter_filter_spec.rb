require 'spec_helper'
require 'parameter_filter'

describe ParameterFilter do
  describe '#call' do
    context 'when the params is not a hash' do
      subject { described_class.new([]) }

      it 'returns nil' do
        expect(subject.call('')).to be_nil
      end
    end

    context 'when the params has one level' do
      subject { described_class.new([:foo]) }

      it 'replaces the filtered parameters' do
        params = { foo: 'bar', bar: 'foo' }
        expect(subject.call(params)).to eql(foo: '[FILTERED]', bar: 'foo')
      end
    end

    context 'when the params has more than one levels' do
      subject { described_class.new(['bar.xyz']) }

      it 'replaces the filtered parameters' do
        params = { foo: 'bar', bar: { xyz: 'foo', abc: 'xyz' } }
        expect(subject.call(params)).to eql(foo: 'bar', bar: { xyz: '[FILTERED]', abc: 'xyz' })
      end
    end

    context 'when the params has the same attribute in different levels' do
      subject { described_class.new([:foo]) }

      it 'replaces the filtered parameters' do
        params = { foo: 'bar', bar: { foo: 'foo', abc: 'xyz' } }
        expect(subject.call(params)).to eql(foo: '[FILTERED]', bar: { foo: 'foo', abc: 'xyz' })
      end
    end

    context 'when the params has the siblings hashs with the same attribute' do
      subject { described_class.new([:foo, 'bar.foo', 'xyz.abc']) }

      it 'replaces the filtered parameters' do
        params = { foo: 'bar', bar: { foo: 'foo', abc: 'xyz' }, xyz: { foo: 'foo', abc: 'xyz' } }
        expect(subject.call(params)).to eql(
          {
            foo: '[FILTERED]',
            bar: { foo: '[FILTERED]', abc: 'xyz' },
            xyz: { foo: 'foo', abc: '[FILTERED]' }
          }
        )
      end
    end
  end
end
