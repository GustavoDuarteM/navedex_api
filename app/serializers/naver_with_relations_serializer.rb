class NaverWithRelationsSerializer < NaverSerializer
  set_type :naver
  has_many :projects
end