require 'test_helper'

require 'roma-test-storage'
require 'roma/storage/hash'

class HashStorageTest < Test::Unit::TestCase
  self.test_order = :defined
  include StorageTests

  def setup
    @st=Roma::Storage::HashStorage.new
    @st.vn_list = [0,1,2,3,4,5,6,7,8,9]
    @st.opendb
  end

  def teardown
  end

  def test_database_stats
    assert_equal([], @st.database_stats)
  end

  def test_cmp_clk
    (0x001E00000..0x002000000).each{|clk|
      assert_equal(0, @st.send(:cmp_clk,clk, clk) )
    }

    (0x001E00000..0x002000000).each{|clk|
      assert_operator(0,:>, @st.send(:cmp_clk,clk-1, clk) )
      assert_operator(0,:<, @st.send(:cmp_clk,clk, clk-1) )
    }

    (0x001E00000..0x002000000).each{|clk|
      assert_operator(0,:<, @st.send(:cmp_clk,clk+1, clk) )
      assert_operator(0,:>, @st.send(:cmp_clk,clk, clk+1) )
    }
    # t1=0 t2=0 clk2=0b0000...
    clk1=0x00000010
    clk2=0x00000000
    assert_operator(0,:<, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:>, @st.send(:cmp_clk,clk2, clk1) )
    # t1=0 t2=1 clk2=0b0010...
    clk2=0x20000000
    assert_operator(0,:>, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:<, @st.send(:cmp_clk,clk2, clk1) )
    # t1=0 t2=2 clk2=0b0100...
    clk2=0x40000000
    assert_operator(0, :>, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0, :<, @st.send(:cmp_clk,clk2, clk1) )
    # t1=0 t2=3 clk2=0b0110...
    clk2=0x60000000
    assert_operator(0,:>, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:<, @st.send(:cmp_clk,clk2, clk1) )
    # t1=0 t2=4 clk2=0b1000...
    clk2=0x80000000
    assert_operator(0,:>, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:<, @st.send(:cmp_clk,clk2, clk1) )

    # t1=0 t2=5 clk2=0b1010...
    clk2=0xa0000000
    assert_operator(0,:<, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:>, @st.send(:cmp_clk,clk2, clk1) )
    # t1=0 t2=6 clk2=0b1100...
    clk2=0xc0000000
    assert_operator(0,:<, @st.send(:cmp_clk,clk1, clk2))
    assert_operator(0,:>, @st.send(:cmp_clk,clk2, clk1))
    # t1=0 t2=7 clk2=0b1110...
    clk2=0xe0000000
    assert_operator(0,:<, @st.send(:cmp_clk,clk1, clk2) )
    assert_operator(0,:>, @st.send(:cmp_clk,clk2, clk1) )
  end

end

class RubyHashStorageNameTest < Test::Unit::TestCase
  # The old name still works, with a warning.
  def test_deprecated_name
    require 'stringio'
    require 'roma/storage/ruby_hash_storage'
    saved_stderr = $stderr
    saved = Warning[:deprecated]
    Warning[:deprecated] = true
    $stderr = StringIO.new
    assert_same Roma::Storage::HashStorage, Roma::Storage::RubyHashStorage
    assert_match(/RubyHashStorage is deprecated/, $stderr.string)
  ensure
    $stderr = saved_stderr
    Warning[:deprecated] = saved
  end

  def test_storage
    out = IO.popen([RbConfig.ruby, '-Ilib', '-e', 'require "roma/storage"; print Roma::Storage::HashStorage'], &:read)
    assert_equal 'Roma::Storage::HashStorage', out
  end
end
