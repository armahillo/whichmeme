# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

DATA_DIR = File.join(Rails.root, 'data')
FAILED_DIR = File.join(DATA_DIR, 'failed')
QUEUED_DIR = File.join(DATA_DIR, 'queue')
ARCHIVE_DIR = File.join(DATA_DIR, 'archive')

STATUS = Status.new
