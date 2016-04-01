class FileUploader < CarrierWave::Uploader::Base
    delegate :identifier, to: :file

    storage :file

    def extension_white_list
        %w(csv)
    end

    def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
end
