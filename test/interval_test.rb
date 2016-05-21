#!/usr/bin/env ruby
require "awesome_print"

require 'bigdecimal'
require 'awesome_print'

require 'test/unit'
require '../ruby/interval.rb'


class TestInterval < Test::Unit::TestCase
  def setup
  end

  def test_interval
    # 第 n..m 次复习的间隔必须大于 多少天
    assert_compare Interval.diff(0..1), "<=", 1
    assert_compare Interval.diff(1..2), ">=", 2
    assert_compare Interval.diff(2..3), ">=", 3
    assert_compare Interval.diff(3..4), ">=", 4
    assert_compare Interval.diff(4..5), ">=", 5
    assert_compare Interval.diff(5..6), ">=", 6
    assert_compare Interval.diff(6..7), ">=", 7
    assert_compare Interval.diff(7..8), ">=", 8
    assert_compare Interval.diff(8..9), ">=", 14
    assert_compare Interval.diff(9..10), ">=", 21
    assert_compare Interval.diff(10..11), ">=", 56
    assert_compare Interval.diff(11..12), ">=", 84
    assert_compare Interval.diff(12..13), ">=", 168
    assert_compare Interval.diff(13..14), ">=", 336
    assert_compare Interval.diff(14..15), ">=", 336
    assert_compare Interval.diff(15..16), ">=", 672
    assert_compare Interval.diff(16..17), ">=", 672
    assert_compare Interval.diff(17..18), ">=", 1008

  end

  def test_only_30_words
    hash = {}
    sum = 0
    (0..17).each do |n|
      sum += Interval.diff(n..(n+1))
      hash[sum] = 30
    end
    # puts hash

  end
  def test_30_new_words_every_day
    hash = Hash.new
    (0..365).each do |day|
      sum = 0
      (0..17).each do |n|
        hash[sum + day] = 0 unless hash.include? sum+day
        hash[sum + day] += 33
        sum += Interval.diff(n..(n+1))
      end
    end
    sortHash = hash.sort_by { |day, number| day  }

    p sortHash[0..365]


  end

end
