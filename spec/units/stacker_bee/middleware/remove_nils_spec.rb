describe StackerBee::Middleware::RemoveNils do
  it 'removes pairs with nil values from the params' do
    expect(subject.transform_params(something: 'something', nothing: nil))
      .to eq something: 'something'
  end
end
