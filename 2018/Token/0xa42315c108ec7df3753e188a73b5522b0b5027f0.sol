['pragma solidity ^0.4.20;\n', '\n', 'contract OptionToken {\n', '\n', '    address public owner;\n', '// 以下是基于ERC20生成代币逻辑\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint public totalSupply;\n', '    \n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    \n', '    event Burn(address indexed from, uint value);\n', '    \n', '    constructor (\n', '        uint initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol,\n', '        uint8 tokenDecimals\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint(tokenDecimals);\n', '        balanceOf[msg.sender] = totalSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        owner = msg.sender;\n', '        decimals = tokenDecimals;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal returns (bool) {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(add(balanceOf[_to],_value) >= balanceOf[_to]);\n', '        uint previousBalances = add(balanceOf[_from],balanceOf[_to]);\n', '        balanceOf[_from] = sub(balanceOf[_from],_value);\n', '        balanceOf[_to] = add(balanceOf[_to],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(add(balanceOf[_from],balanceOf[_to]) == previousBalances);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] = sub(allowance[_from][msg.sender],_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = sub(balanceOf[msg.sender],_value);\n', '        totalSupply = sub(totalSupply,_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] = sub(balanceOf[_from],_value);\n', '        allowance[_from][msg.sender] = sub(allowance[_from][msg.sender],_value);\n', '        totalSupply = sub(totalSupply,_value);\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '// 以上是基于ERC20生成代币逻辑\n', '\n', '\n', '// 以下是公共判断及基本方法\n', '    // 判断是否为owner地址\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    // 更改owner地址\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        if (newOwner != address(0))\n', '            owner = newOwner;\n', '    }\n', '    // 摧毁该智能合约\n', '    function selfdestruct() external onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    bool public status = true;// 判断该合约状态\n', '\n', '    modifier checkStatus() {\n', '        require(status == true);\n', '        _;\n', '    }\n', '\n', '    function unlockContract() external onlyOwner {\n', '        require(!status);\n', '        status = true;\n', '    }\n', '\n', '    function lockContract() external onlyOwner {\n', '        require(status);\n', '        status = false;\n', '    }\n', '\n', '    mapping (address => uint) whitelist;// 白名单列表\n', '\n', '    function addWhiteList (address _user, uint _amount) public onlyOwner checkStatus {\n', '        whitelist[_user] = _amount;\n', '    }\n', '\n', '    function removeWhiteList (address _user) public onlyOwner checkStatus {\n', '        delete whitelist[_user];\n', '    }\n', '\n', '    function isAllowTransfer(address _user) public view returns (bool) {\n', '        return whitelist[_user] == 0 ? false : true;\n', '    }\n', '\n', '    function getAllowAmount(address _user) public view returns (uint) {\n', '        return whitelist[_user];\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '// 以上是公共判断及基本方法\n', '\n', '// 以下是授予公共模块\n', '\n', '    event issueEvent(bytes32 issueKey);\n', '\n', '    struct IssueStruct {\n', '        // 授予数量\n', '        uint issueAmount;\n', '        // 授予日期\n', '        uint32 issueDate;\n', '        // 成熟起算日\n', '        uint32 vestingStartDate;\n', '    }\n', '    \n', '    mapping (address => mapping (bytes32 => IssueStruct)) public issueList;\n', '\n', '\n', '    // 授予\n', '    function issue ( \n', '        address _issueAddress, uint _issueAmount,\n', '        uint32 _issueDate,uint32 _vestingStartDate \n', '    ) \n', '        external \n', '        checkStatus \n', '        onlyOwner \n', '        returns (bool)\n', '    {\n', '        require(_issueAddress != 0x0);\n', '        require(_issueDate != 0);\n', '        require(_vestingStartDate != 0);\n', '        \n', '        uint nowTime = block.timestamp;\n', '        bytes32 issueKey = sha256(_issueAddress, _issueAmount, _issueDate, _vestingStartDate, nowTime);\n', '        // 授予\n', '        issueList[_issueAddress][issueKey] = IssueStruct({\n', '            issueAmount: _issueAmount,\n', '            issueDate: _issueDate,\n', '            vestingStartDate: _vestingStartDate\n', '        });\n', '\n', '        emit issueEvent(issueKey);\n', '        return true;\n', '    }\n', '\n', '    // 根据address、key 查看授予详情\n', '    function showIssueDetail ( address _issueAddress, bytes32 _issueKey ) \n', '        public \n', '        view \n', '        returns ( uint, uint32, uint32 ) \n', '    {\n', '        require(hasIssue(_issueAddress, _issueKey));\n', '        IssueStruct storage issueDetail = issueList[_issueAddress][_issueKey];\n', '        return ( \n', '            issueDetail.issueAmount, issueDetail.issueDate, \n', '            issueDetail.vestingStartDate\n', '        );\n', '    }\n', '\n', '    // 通过address 和 key 判断是否有该授予纪录\n', '    function hasIssue ( address _issueAddress, bytes32 _issueKey )\n', '        internal \n', '        view \n', '        returns (bool)\n', '    {\n', '        if (issueList[_issueAddress][_issueKey].issueAmount != 0) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '// 以上是授予模块\n', '\n', '// 以下是成熟列表展示模块\n', '    function reveiveToken ( address _issueAddress, uint amount ) \n', '        external\n', '        onlyOwner\n', '        checkStatus\n', '    {\n', '        _transfer(owner, _issueAddress, amount);\n', '    }\n', '// 以上是成熟列表展示模块\n', '}']