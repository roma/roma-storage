# Deprecated: require 'roma/storage/hash' and use Roma::Storage::HashStorage.
require 'roma/storage/hash'

module Roma
  module Storage
    RubyHashStorage = HashStorage
    deprecate_constant :RubyHashStorage
  end
end
