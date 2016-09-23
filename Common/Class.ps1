# PowerShell 5.0 后可以创建 Class
# 但是还缺乏访问控制等一些 OOP Class 的构造
Class BaseClass{
    # 属性
    [String]$name = ''
    [DateTime]$birthday = (Get-Date)

    # 构造函数
    BaseClass() {
        $this.name = "Default Name"
    }

    BaseClass([String]$namePar) {
        $this.name = $namePar
    }

    # 实例方法
    [String]toString() { 
        return "Name : $($this.name), Birthday : $($this.birthday.ToString())."
    }

    # 静态变量
    Static [String] $className = 'BaseClass'

    # 静态方法
    Static [String] getClassName() {
        return [BaseClass]::className
    }
}

# 可以继承 Class
Class SubClass : BaseClass {
    
    # base(...) 调用父类构造函数
    SubClass() : base('Sub Class') {}

    # 可以 Override 方法
    [String]toString() {
        # 通过将 $this 转型，可以调用父类方法
        return "Sub Class : $(([BaseClass]$this).toString())"
    }
}

# 获取静态变量
$v = [BaseClass]::className

# 调用静态方法
$v = [BaseClass]::getClassName()

# 创建实例
[BaseClass]$instance = [BaseClass]::new()

# 调用实例方法
$v = $instance.ToString()

$v = [SubClass]::new()
$v.toString()