#encoding: UTF-8

module CodeHelper

  @response = Hash.new

  def self.CODE_SUCCESS

    @response[:code] = "200"
    @response[:desc] = "成功"
    return @response
  end

  def self.CODE_FAIL

    @response[:code] = "222"
    @response[:desc] = "操作失败"
    return @response
  end

  def self.CODE_MISSING_PARAMS

    @response[:code] = "223"
    @response[:desc] = "缺少参数"
    return @response
  end

  def self.CODE_MISSING_PARAMS_POST_ID

    @response[:code] = "227"
    @response[:desc] = "缺少帖子id"
    return @response
  end

  def self.CODE_MISSING_PARAMS_USER_ID

    @response[:code] = "299"
    @response[:desc] = "缺少用户ID"
    return @response
  end

  def self.CODE_USER_NOT_EXIST

    @response[:code] = "225"
    @response[:desc] = "用户不存在"
    return @response
  end

  def self.CODE_TOKEN_NOT_EXIST

    @response[:code] = "228"
    @response[:desc] = "用户token不存在或者失效"
    return @response
  end

  def self.CODE_PASSPORT_TOKEN_NOT_EXIST

    @response[:code] = "228"
    @response[:desc] = "用户passport token不存在或者失效"
    return @response
  end

end
