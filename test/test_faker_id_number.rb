# frozen_string_literal: true

require_relative 'test_helper'

class TestFakerIdNumber < Test::Unit::TestCase
  def setup
    @tester = Faker::IDNumber
  end

  def test_valid_ssn
    sample = @tester.valid
    assert sample.length == 11
    assert_equal '-', sample[3]
    assert_equal '-', sample[6]
    assert sample[0..2].split.map { :to_i }.all? { :is_digit? }
    assert sample[4..5].split.map { :to_i }.all? { :is_digit? }
    assert sample[7..9].split.map { :to_i }.all? { :is_digit? }
  end

  def test_invalid_ssn
    sample = @tester.invalid
    assert sample.length == 11
    assert_equal '-', sample[3]
    assert_equal '-', sample[6]
    assert sample[0..2].split.map { :to_i }.all? { :is_digit? }
    assert sample[4..5].split.map { :to_i }.all? { :is_digit? }
    assert sample[7..9].split.map { :to_i }.all? { :is_digit? }
  end

  def test_spanish_dni
    sample = @tester.spanish_citizen_number
    assert_equal 10, sample.length
    assert sample[0..7].split.map { :to_i }.all? { :is_digit? }
    assert_equal sample[8], '-'
    mod = sample[0..7].to_i % 23
    assert_equal Faker::IDNumber::CHECKS[mod], sample[9]
  end

  def test_spanish_nie
    sample = @tester.spanish_foreign_citizen_number
    assert_equal 11, sample.length
    assert 'XYZ'.include?(sample[0])
    assert_equal '-', sample[1]
    assert sample[2..8].split.map { :to_i }.all? { :is_digit? }
    assert_equal '-', sample[9]
    prefix = 'XYZ'.index(sample[0]).to_s
    mod = "#{prefix}#{sample[2..8]}".to_i % 23
    assert_equal Faker::IDNumber::CHECKS[mod], sample[10]
  end

  def test_valid_south_african_id_number
    sample = @tester.valid_south_african_id_number
    assert_equal 13, sample.length
    assert_match(/^\d{13}$/, sample)
    date_of_birth_string = "19#{sample[0..1]}/#{sample[2..3]}/#{sample[4..5]}}"
    assert Date.parse(date_of_birth_string)
    assert_include [0, 1], sample[10].to_i
    assert_equal '8', sample[11]
  end
end
