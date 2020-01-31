RSpec.shared_examples 'color validatable' do |attribute, default_value: false|
  it { should allow_value('#1f1f1F').for(attribute) }

  it { should allow_value('#AFAFAF').for(attribute) }

  it { should allow_value('#222fff').for(attribute) }

  it { should allow_value('#F00').for(attribute) }

  it { should allow_value('#1AFFa1').for(attribute) }

  it { should allow_value('#000000').for(attribute) }

  it { should allow_value('#ea00FF').for(attribute) }

  it { should allow_value('#eb0').for(attribute) }

  it { should allow_value(nil).for(attribute) }

  it { should_not allow_value('123456').for(attribute) }

  it { should_not allow_value('#afafah').for(attribute) }

  it { should_not allow_value('#123abce').for(attribute) }

  it { should_not allow_value('aFaE3f').for(attribute) }

  it { should_not allow_value('F00').for(attribute) }

  it { should_not allow_value('#afaf').for(attribute) }

  it { should_not allow_value('#afaf').for(attribute) }

  it { should_not allow_value('#F0h').for(attribute) }

  unless default_value
    it { should_not allow_value('').for(attribute) }
  end

  it { should_not allow_value(0).for(attribute) }

  it { should_not allow_value('#1f1f1F1f1f1F').for(attribute) }
end
