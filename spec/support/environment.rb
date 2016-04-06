## 
# Some helper functions to setup the environment
##

##
# create_established_meme_type
#    Established meme types have 6 instances of memes under them.
##
def create_established_memetype(attributes = {})
  mt = create(:meme_type, attributes)
  puts "[SETUP::Created MemeType]: #{mt.name}"
  establish_memetype(mt)
  return mt
end

def establish_memetype(meme_type)
  print "[SETUP::Seeding Meme Data]:"
  6.times { create(:meme, meme_type: meme_type); print "." }	
  puts ""
end