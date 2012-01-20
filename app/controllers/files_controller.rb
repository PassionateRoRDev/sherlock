#
# Controller that will be used to serve files with proper access control
#
class FilesController < ApplicationController
  
  before_filter :authenticate_user!

  
end