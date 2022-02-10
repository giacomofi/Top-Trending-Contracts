['pragma solidity ^0.4.23;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath32\n', ' * @dev SafeMath library implemented for uint32\n', ' */\n', 'library SafeMath32 {\n', '\n', '    function mul(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        if (a == 0) {\n', '            return 0;\n', '       }\n', '        uint32 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint32 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        uint32 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath16\n', ' * @dev SafeMath library implemented for uint16\n', ' */\n', 'library SafeMath16 {\n', '\n', '    function mul(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint16 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint16 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        uint16 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract StudentFactory is Ownable{\n', '\n', '    struct Student{\n', '        string name;// 姓名\n', '        string nation;// 民族\n', '        string id;// 证件号\n', '        uint32 birth;// 生日\n', '        bytes1 gender;// 性别\n', '    } \n', '    \n', '    struct Undergraduate{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct Master{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct Doctor{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct CET4{\n', '        uint32 time; //时间，如2017年12月\n', '        uint32 grade;// 分数\n', '    }\n', '\n', '    struct CET6{\n', '        uint32 time; //时间，如2017年12月\n', '        uint32 grade;// 分数\n', '    }\n', '\n', '    Student[] students;// 学生列表\n', '    CET4[] CET4List; // 四级成绩列表\n', '    CET6[] CET6List; // 六级成绩列表\n', '    mapping (address=>Student) public addrToStudent;// 地址到学生的映射\n', '    mapping (uint=>address) internal CET4IndexToAddr; // 四级成绩序号到地址的映射\n', '    mapping (uint=>address) internal CET6IndexToAddr; // 六级成绩序号到地址的映射\n', '    mapping (address=>uint) public addrCET4Count; //地址到四级成绩数量映射\n', '    mapping (address=>uint) public addrCET6Count; //地址到六级成绩数量映射\n', '    mapping (address=>Undergraduate) public addrToUndergaduate;// 地址到本科学籍的映射\n', '    mapping (address=>Master) public addrToMaster;// 地址到硕士学籍的映射\n', '    mapping (address=>Doctor) public addrToDoctor;// 地址到博士学籍的映射\n', '   \n', '    // 定义判断身份证是否被使用的modifier\n', '    modifier availableIdOf(string _id) {\n', '        require(_isIdExisted(_id));\n', '        _;\n', '    }\n', '\n', '    // 判断证件号码是否已注册\n', '    function _isIdExisted(string _id) private view returns(bool){\n', '        for(uint i = 0;i<students.length;i++){\n', '            if(keccak256(students[i].id)==keccak256(_id)){\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    // 创建学生\n', '    function createStudent(string _name,string _nation,string _id,uint32 _birth,bytes1 _gender) public availableIdOf(_id){\n', '        Student memory student = Student(_name,_nation,_id,_birth,_gender);\n', '        addrToStudent[msg.sender] = student;\n', '        students.push(student);\n', '    }\n', '}\n', 'contract StudentHelper is StudentFactory{\n', '    using SafeMath for uint;\n', '    // 给某个地址的人添加本科学籍信息\n', '    function addUndergraduateTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToUndergaduate[_addr] = Undergraduate(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址的人添加硕士学籍信息\n', '    function addMasterTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToMaster[_addr] = Master(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址的人添加博士学籍信息\n', '    function addDoctorTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToDoctor[_addr] = Doctor(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址添加四级成绩记录\n', '    function addCET4To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{\n', '        uint index = CET4List.push(CET4(_time,_grade))-1;\n', '        CET4IndexToAddr[index] = _addr;\n', '        addrCET4Count[_addr]++;\n', '    }\n', '\n', '    // 给某个地址添加六级成绩记录\n', '    function addCET6To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{\n', '        uint index = CET6List.push(CET6(_time,_grade))-1;\n', '        CET6IndexToAddr[index] = _addr;\n', '        addrCET6Count[_addr]++;\n', '    }\n', '\n', '    // 获得某个地址的四级成绩\n', '    function getCET4ByAddr(address _addr) view public returns (uint32[],uint32[]) {\n', '        uint32[] memory timeList = new uint32[](addrCET4Count[_addr]); \n', '        uint32[] memory gradeList = new uint32[](addrCET4Count[_addr]);\n', '        uint counter = 0;    \n', '        for (uint i = 0; i < CET4List.length; i++) {\n', '            if(CET4IndexToAddr[i]==_addr){\n', '                timeList[counter] = CET4List[i].time;\n', '                gradeList[counter] = CET4List[i].grade;\n', '                counter++;\n', '            }\n', '        }\n', '        return(timeList,gradeList);\n', '    }\n', '\n', '    // 获得某个地址的六级成绩\n', '    function getCET6ByAddr(address _addr) view public returns (uint32[],uint32[]) {\n', '        uint32[] memory timeList = new uint32[](addrCET6Count[_addr]); \n', '        uint32[] memory gradeList = new uint32[](addrCET6Count[_addr]);\n', '        uint counter = 0;    \n', '        for (uint i = 0; i < CET6List.length; i++) {\n', '            if(CET6IndexToAddr[i]==_addr){\n', '                timeList[counter] = CET6List[i].time;\n', '                gradeList[counter] = CET6List[i].grade;\n', '                counter++;\n', '            }\n', '        }\n', '        return(timeList,gradeList);\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title SafeMath32\n', ' * @dev SafeMath library implemented for uint32\n', ' */\n', 'library SafeMath32 {\n', '\n', '    function mul(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        if (a == 0) {\n', '            return 0;\n', '       }\n', '        uint32 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint32 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32) {\n', '        uint32 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath16\n', ' * @dev SafeMath library implemented for uint16\n', ' */\n', 'library SafeMath16 {\n', '\n', '    function mul(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint16 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint16 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        uint16 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract StudentFactory is Ownable{\n', '\n', '    struct Student{\n', '        string name;// 姓名\n', '        string nation;// 民族\n', '        string id;// 证件号\n', '        uint32 birth;// 生日\n', '        bytes1 gender;// 性别\n', '    } \n', '    \n', '    struct Undergraduate{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct Master{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct Doctor{\n', '        string studentId; // 学籍号\n', '        string school;// 学校 \n', '        string major;// 专业\n', '        uint8 length;// 学制\n', '        uint8 eduType;// 学历类别\n', '        uint8 eduForm;// 学习形式\n', '        uint8 class;// 班级\n', '        uint8 level;// 层次(专/本/硕/博)\n', '        uint8 state;// 学籍状态\n', '        uint32 admissionDate;// 入学日期\n', '        uint32 departureDate;// 离校日期\n', '    }\n', '\n', '    struct CET4{\n', '        uint32 time; //时间，如2017年12月\n', '        uint32 grade;// 分数\n', '    }\n', '\n', '    struct CET6{\n', '        uint32 time; //时间，如2017年12月\n', '        uint32 grade;// 分数\n', '    }\n', '\n', '    Student[] students;// 学生列表\n', '    CET4[] CET4List; // 四级成绩列表\n', '    CET6[] CET6List; // 六级成绩列表\n', '    mapping (address=>Student) public addrToStudent;// 地址到学生的映射\n', '    mapping (uint=>address) internal CET4IndexToAddr; // 四级成绩序号到地址的映射\n', '    mapping (uint=>address) internal CET6IndexToAddr; // 六级成绩序号到地址的映射\n', '    mapping (address=>uint) public addrCET4Count; //地址到四级成绩数量映射\n', '    mapping (address=>uint) public addrCET6Count; //地址到六级成绩数量映射\n', '    mapping (address=>Undergraduate) public addrToUndergaduate;// 地址到本科学籍的映射\n', '    mapping (address=>Master) public addrToMaster;// 地址到硕士学籍的映射\n', '    mapping (address=>Doctor) public addrToDoctor;// 地址到博士学籍的映射\n', '   \n', '    // 定义判断身份证是否被使用的modifier\n', '    modifier availableIdOf(string _id) {\n', '        require(_isIdExisted(_id));\n', '        _;\n', '    }\n', '\n', '    // 判断证件号码是否已注册\n', '    function _isIdExisted(string _id) private view returns(bool){\n', '        for(uint i = 0;i<students.length;i++){\n', '            if(keccak256(students[i].id)==keccak256(_id)){\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    // 创建学生\n', '    function createStudent(string _name,string _nation,string _id,uint32 _birth,bytes1 _gender) public availableIdOf(_id){\n', '        Student memory student = Student(_name,_nation,_id,_birth,_gender);\n', '        addrToStudent[msg.sender] = student;\n', '        students.push(student);\n', '    }\n', '}\n', 'contract StudentHelper is StudentFactory{\n', '    using SafeMath for uint;\n', '    // 给某个地址的人添加本科学籍信息\n', '    function addUndergraduateTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToUndergaduate[_addr] = Undergraduate(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址的人添加硕士学籍信息\n', '    function addMasterTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToMaster[_addr] = Master(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址的人添加博士学籍信息\n', '    function addDoctorTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) \n', '    public onlyOwner{\n', '        addrToDoctor[_addr] = Doctor(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);\n', '    }\n', '\n', '    // 给某个地址添加四级成绩记录\n', '    function addCET4To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{\n', '        uint index = CET4List.push(CET4(_time,_grade))-1;\n', '        CET4IndexToAddr[index] = _addr;\n', '        addrCET4Count[_addr]++;\n', '    }\n', '\n', '    // 给某个地址添加六级成绩记录\n', '    function addCET6To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{\n', '        uint index = CET6List.push(CET6(_time,_grade))-1;\n', '        CET6IndexToAddr[index] = _addr;\n', '        addrCET6Count[_addr]++;\n', '    }\n', '\n', '    // 获得某个地址的四级成绩\n', '    function getCET4ByAddr(address _addr) view public returns (uint32[],uint32[]) {\n', '        uint32[] memory timeList = new uint32[](addrCET4Count[_addr]); \n', '        uint32[] memory gradeList = new uint32[](addrCET4Count[_addr]);\n', '        uint counter = 0;    \n', '        for (uint i = 0; i < CET4List.length; i++) {\n', '            if(CET4IndexToAddr[i]==_addr){\n', '                timeList[counter] = CET4List[i].time;\n', '                gradeList[counter] = CET4List[i].grade;\n', '                counter++;\n', '            }\n', '        }\n', '        return(timeList,gradeList);\n', '    }\n', '\n', '    // 获得某个地址的六级成绩\n', '    function getCET6ByAddr(address _addr) view public returns (uint32[],uint32[]) {\n', '        uint32[] memory timeList = new uint32[](addrCET6Count[_addr]); \n', '        uint32[] memory gradeList = new uint32[](addrCET6Count[_addr]);\n', '        uint counter = 0;    \n', '        for (uint i = 0; i < CET6List.length; i++) {\n', '            if(CET6IndexToAddr[i]==_addr){\n', '                timeList[counter] = CET6List[i].time;\n', '                gradeList[counter] = CET6List[i].grade;\n', '                counter++;\n', '            }\n', '        }\n', '        return(timeList,gradeList);\n', '    }\n', '}']