# == Schema Information
#
# Table name: samples
#
#  id         :bigint           not null, primary key
#  name       :string(10)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Sample, type: :model do

  it 'array match test' do
    expect([
      [:a, :aa],
      ['b', 'bb'],
      [1, 11],
      [true, false],
      { a: 1, b: 2 }
    ]).to match_array([
      [true, false],
      [1, 11],
      ['b', 'bb'],
      [:a, :aa], # does not match if elements in sub-array are different order
      { b: 2, a: 1 } # works if elements in hash are specified in different order
    ])
    # match_array calls contain_exactly
    # contain_exactly calls BuiltIn::ContainExactly.new
    # BuiltIn::ContainExactly.match calls match_when_sorted?
    # match_when_sorted calls? sorts then calls RSpec::Matchers::Composable.values_match?
    # RSpec::Matchers::Composable.values_match? calls Support::FuzzyMatcher.values_match?
    # Support is part of rspec-support
    # FuzzyMatcher(self).values_match? calls hashes_match? and arrays_match?
    # arrays_match? does a comparison of each element - recursive (note: sub arrays don't get sorted before compared)
    # hashes_match does a comparison by iterating over expected and doing a lookup on actual - recursive
  end

  it 'nested hash match test' do
    expect({
      a: { b: 2 }
    }).to match({
      a: { b: 2 }
    })
  end

  it 'composed hash match test' do
    expect({
      a: 1
    }).to match({
      a: an_instance_of(Integer)
    })
    # https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/composing-matchers#composing-matchers-with-%60match%60:
  end

  it 'hash include test' do
    expect({
      a: 1,
      b: 2
    }).to include(
      a: 1
    )
  end

  it 'valid creation' do
    expect { Sample.create!(name: 'a') }.not_to raise_error
  end

  it 'fails if blank' do
    errors = Sample.create(name: nil).errors.map { |x| [ x.attribute, x.type ] }
    expect(errors).to match_array([
      [:name, :blank],
      [:name, :too_short]
    ])
  end

  it 'fails if too short' do
    errors = Sample.create(name: '').errors.map { |x| [ x.attribute, x.type ] }
    expect(errors).to match_array([
      [:name, :blank],
      [:name, :too_short]
    ])
  end

  it 'fails if too long' do
    errors = Sample.create(name: 'abcdefghijk').errors.map { |x| [ x.attribute, x.type ] }
    expect(errors).to match_array([
      [:name, :too_long]
    ])
  end

  it 'fails with whitespace' do
    errors = Sample.create(name: ' a').errors.map { |x| [ x.attribute, x.type ] }
    expect(errors).to match_array([
      [:name, :disallowed_characters]
    ])
  end

  it 'fails with non alpha' do
    errors = Sample.create(name: 'a1').errors.map { |x| [ x.attribute, x.type ] }
    expect(errors).to match_array([
      [:name, :disallowed_characters]
    ])
  end

end
