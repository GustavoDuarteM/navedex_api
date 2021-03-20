class ProjectWithRelationsSerializer < ProjectSerializer
  set_type :project
  has_many :navers
end
