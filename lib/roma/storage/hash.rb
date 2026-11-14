require 'roma/storage/basic_storage'

module Roma
  module Storage

    module RH_Ext
      def put(k,v); self[k] = v; end
      def get(k); self[k]; end
      def out(k); delete(k); end
      def rnum; length; end
      def sync; true; end
    end

    class HashStorage < BasicStorage

      def opendb
        create_div_hash
        @divnum.times do |i|
          @hdb[i] = open_db(nil)
          @hdbc[i] = nil
          @dbs[i] = :normal
        end
      end

      if RUBY_VERSION >= '1.9.2'
        # Yields the keys that the database has when it starts: a Hash can't
        # take a new key while it is iterated, and the requests set keys
        # while each_clean_up sleeps. A key deleted meanwhile is skipped.
        def each_record(hdb)
          hdb.keys.each do |k|
            v = hdb[k]
            yield k, v if v
          end
        end

        def each_unpacked_db(target_vn, db)
          count = 0
          tn =  Time.now.to_i
          keys = db[@hdiv[target_vn]].keys
          keys.each do |k|
            v = db[@hdiv[target_vn]][k]
            vn, last, clk, expt, val = unpack_data(v)
            if vn != target_vn || (expt != 0 && tn > expt)
              count += 1
              sleep @each_vn_dump_sleep if count % @each_vn_dump_sleep_count == 0
              next
            end
            yield vn, last, clk, expt, k, val
          end
        end
        private :each_unpacked_db


        def each_hdb_dump(i,except_vnh = nil)
          count = 0
          keys = @hdb[i].keys
          keys.each{|k|
            v = @hdb[i][k]
            vn, last, clk, expt, val = unpack_data(v)
            if except_vnh && except_vnh.key?(vn) || Time.now.to_i > expt
              count += 1
              sleep @each_vn_dump_sleep if count % @each_vn_dump_sleep_count == 0
            else
              yield [vn, last, clk, expt, k.length, k, val.length, val].pack("NNNNNa#{k.length}Na#{val.length}")
              sleep @each_vn_dump_sleep
            end
          }
        end

        # Create vnode dump.
        def vnode_hash(vn)
          buf = {}
          count = 0
          hdb = @hdb[@hdiv[vn]]
          keys = hdb.keys
          keys.each{ |k|
            v = hdb[k]
            count += 1
            sleep @each_vn_dump_sleep if count % @each_vn_dump_sleep_count == 0
            dat = unpack_data(v) #v.unpack('NNNN')
            buf[k] = v if dat[0] == vn
          }
          return buf
        end
        private :vnode_hash
        
      end

      private

      def open_db(fname)
        hdb = {}
        hdb.extend(Roma::Storage::RH_Ext)
        return hdb
      end

      def close_db(hdb); end

    end # class HashStorage

  end # module Storage
end # module Roma
