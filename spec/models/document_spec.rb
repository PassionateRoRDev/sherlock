require 'spec_helper'
require 'pp'

describe Document do
  
  context "Having one existing Case" do
    before do
      @case = FactoryGirl.create(:case)
    end
    
    context "Creating a document from an uploaded file" do
      
      before do
        filename = 'sample.pdf'   
        data = {
          :filepath           => fixture_file_path(filename),
          :content_type       => 'application/pdf',
          :original_filename  => filename
        }
        uploaded = Uploader.new(data)
        @doc = Document.create(
          :title => 'Sample document', 
          :case => @case,
          :uploaded_file => uploaded
        )      
      end
      
      it 'should have one file asset created' do
        @doc.file_assets.size.should == 1        
      end
      
      it 'should save the original file name' do
        @doc.original_filename.should == 'sample.pdf'
      end
      
      it 'should store the uploaded document in a correct folder' do
        file_asset = @doc.file_assets.first
        Dir[file_asset.base_dir + '/*'].size.should == 1        
      end
      
      it 'should store the correct content type' do
        file_asset = @doc.file_assets.first
        file_asset.content_type.should == "application/pdf"
      end
      
      it 'should store the correct file size' do
        file_asset = @doc.file_assets.first
        filepath = File.join(file_asset.base_dir, file_asset.path)        
        file_asset.filesize.should == File.size(filepath)
      end
      
      it 'should report the correct Document usage' do
        file_asset = @doc.file_assets.first
        @doc.usage.should == File.size(file_asset.full_filepath)
      end
      
      it 'should remove the asset when the document is removed' do
        @doc.destroy
        FileAsset.all.should == []
      end
      
      it 'should remove the file when the document is removed' do
        file_asset = @doc.file_assets.first        
        base_dir = file_asset.base_dir   
        @doc.destroy
        Dir[base_dir + '/*'].should == []
      end
      
      context "uploading a new file over an existing one" do
        before do
          @orig_file_asset = @doc.file_assets.first
          @base_dir = @orig_file_asset.base_dir
        
          filename = 'text_file1.txt'   
          data = {
            :filepath           => fixture_file_path(filename),
            :content_type       => 'text/plain',
            :original_filename  => filename
          }
       
          @doc.uploaded_file = Uploader.new(data)
          @doc.save        
          @doc.reload
        end
        
        it 'should create a new asset when a new file is uploaded' do
          file_asset = @doc.file_assets.first
          file_asset.should_not == @orig_file_asset
        end
        
        it 'should not create a second file asset' do
          @doc.file_assets.size.should == 1          
        end
        
        it 'should remove the old file and store the new one' do
          Dir[@base_dir + '/*'].size.should == 1
        end
        
      end
      
    end
      
  end
    
  context "Creating a Case along with a new Document" do
    
    before do
      filename = 'sample.pdf'   
      data = {
        :filepath           => fixture_file_path(filename),
        :content_type       => 'application/pdf',
        :original_filename  => filename
      }
      uploaded = Uploader.new(data)
            
      @case = Case.new(:title => 'Title', :summary => 'Summary')
      @case.author = FactoryGirl.create(:user)
      @case.document = Document.new(:title => 'Sample1', :uploaded_file  => uploaded)
      
      @case.save
      @case.reload
      
    end    
    
    it 'should store the document record' do
      @case.document should_not be_nil      
    end
    
    it 'the document should have 1 file asset created' do      
      @case.document.file_assets.size.should == 1
    end
    
  end
      
end