['pragma solidity 0.5.16;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface ERC20Interface {\n', '    function totalSupply() external view returns(uint);\n', '    function balanceOf(address owner)  external view returns(uint256 balance);\n', '    function transfer(address to, uint value) external returns(bool success);\n', '    function transferFrom(address _from, address _to, uint256 value)  external returns(bool success);\n', '    function approve(address spender, uint256 value)  external returns(bool success);\n', '    function allowance(address owner, address spender)  external view returns(uint256 remaining);\n', '    \n', '    function Exchange_Price() external view returns(uint256 actual_Price); \n', '    \n', '    function isUser_Frozen(address _user) external view returns (bool);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '//Wealth Builder Club Loyalty Token\n', '\n', 'contract WBCT {\n', '\n', '    using SafeMath for uint;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '    uint public _totalSupply;\n', '    bool public paused = false;\n', '    uint256 adminCount;\n', '    uint256 TOKEN_PRICE;\n', '    address public EXCHNG;\n', '    address public TOKEN_ATM;\n', '    \n', '    address[] public adminListed;\n', '    \n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => uint256) public freezeOf;\n', '    mapping (address => bool) public frozenUser;\n', '    mapping (address => bool) public isBlackListed;\n', '    mapping (address => bool) public registeredUser;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value, uint _time);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value, uint _time);\n', '    \n', '    event DestroyedBlackFunds(address _blackListedUser, uint256 _balance, uint _time);\n', '    event AddedBlackList(address _user, uint _time);\n', '    event RemovedBlackList(address _user, uint _time);\n', '\n', '    event Received(address, uint _value, uint _time);\n', '    event Issue(uint amount, uint _time);\n', '    event Redeem(uint amount, uint _time);\n', '\n', '    event Registered_User(address _user, uint _time);\n', '    event UserFrozen(address _user, address _admin, uint _time);\n', '    event UserUnfrozen(address _user, address _admin, uint _time);\n', '    event Freeze(address indexed from, uint256 value);\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    event AddedAdminList(address _adminUser);\n', '    event RemovedAdminList(address _clearedAdmin);\n', '    \n', '    event Pause();\n', '    event Unpause();\n', '\n', '    function init_Token(uint256 _initialSupply, string memory _name, string memory _symbol, uint256 _decimals) public onlyOwner {\n', '        _totalSupply = _initialSupply* (10 ** _decimals);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        registeredUser[msg.sender]=true;\n', '        frozenUser[msg.sender]=false;\n', '        balanceOf[msg.sender] = _initialSupply * (10 ** _decimals);\n', '    }\n', '\n', '    constructor () public {\n', '        adminListed.push(msg.sender);\n', '        adminCount=1;\n', '        TOKEN_PRICE = 0.001 ether;\n', '    }  \n', '      \n', '    modifier onlyOwner() {\n', '        require(isAdminListed(msg.sender));\n', '        _;\n', '    }    \n', '\n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4));\n', '        _;\n', '    }\n', '    \n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '  \n', '      function isAdminListed(address _maker) public view returns (bool) {\n', '        require(_maker != address(0));\n', '        bool status = false;\n', '        for(uint256 i=0;i<adminCount;i++){\n', '            if(adminListed[i] == _maker) { status = true; }\n', '        }\n', '        return status;\n', '    }\n', '\n', '     function getOwner() public view returns (address[] memory) {\n', '        address[] memory _adminList = new address[](adminCount);\n', '        for(uint i=0;i<adminCount;i++){\n', '            _adminList[i]=adminListed[i];\n', '        }\n', '    return _adminList;\n', '    }\n', '\n', '    function addAdminList (address _adminUser) public onlyOwner {\n', '        require(_adminUser != address(0));\n', '        require(!isAdminListed(_adminUser));\n', '        adminListed.push(_adminUser);\n', '        adminCount++;\n', '        emit AddedAdminList(_adminUser);\n', '    }\n', '\n', '    function removeAdminList (address _clearedAdmin) public onlyOwner {\n', '        require(isAdminListed(_clearedAdmin) && _clearedAdmin != msg.sender);\n', '        for(uint256 i=0;i<adminCount;i++){\n', '            if(adminListed[i] == _clearedAdmin) { \n', '                adminListed[i]=adminListed[adminListed.length-1];\n', '                delete adminListed[adminListed.length-1];\n', '                adminCount--;\n', '            }\n', '        }\n', '        emit RemovedAdminList(_clearedAdmin);\n', '    }\n', '\n', '    function isUser_Frozen(address _user) public view returns (bool) {\n', '        return frozenUser[_user];\n', '    }\n', '    \n', '    function setUser_Frozen(address _user) public onlyOwner{\n', '        frozenUser[_user] = true;\n', '        emit UserFrozen(_user, msg.sender, now);\n', '    }\n', '    \n', '    function setUser_unFrozen(address _user) public onlyOwner{\n', '        frozenUser[_user] = false;\n', '        emit UserUnfrozen(_user, msg.sender, now);\n', '    }\n', '    \n', '    function getBlackListStatus(address _user) public view returns (bool) {\n', '        return isBlackListed[_user];\n', '    }\n', '    \n', '    function addBlackList (address _evilUser) public onlyOwner {\n', '        isBlackListed[_evilUser] = true;\n', '        emit AddedBlackList(_evilUser,now);\n', '    }\n', '\n', '    function removeBlackList (address _clearedUser) public onlyOwner {\n', '        isBlackListed[_clearedUser] = false;\n', '        emit RemovedBlackList(_clearedUser,now);\n', '    }\n', '\n', '    function destroyBlackFunds (address _blackListedUser) public onlyOwner {\n', '        require(isBlackListed[_blackListedUser]);\n', '        uint dirtyFunds = balanceOf[_blackListedUser];\n', '        balanceOf[_blackListedUser] = 0;\n', '        _totalSupply -= dirtyFunds;\n', '        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds,now);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(!frozenUser[_to]);\n', '        require(!frozenUser[msg.sender]);\n', '        _transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to,_value,now);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != address(0));\n', '        require(!frozenUser[_from]);\n', '        require(!frozenUser[_to]);\n', '        require(!frozenUser[msg.sender]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value,now);\n', '    }    \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(_value > 0);\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowed[_from][msg.sender] || _to == EXCHNG || _to == TOKEN_ATM);\n', '        require(!frozenUser[_from]);\n', '        require(!frozenUser[_to]);\n', '        require(!frozenUser[msg.sender]);\n', '        if( _to != TOKEN_ATM && _to != EXCHNG ) allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(!frozenUser[_spender]);\n', '        require(!frozenUser[msg.sender]);\n', '        require(_value != 0);\n', '        require(_spender != address(0));\n', '        require( balanceOf[msg.sender] >= _value );\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value,now);\n', '        return true;\n', '    }\n', '    \n', '    function freeze(uint256 _value) public returns (bool success) {\n', '        require(!frozenUser[msg.sender]);\n', '        require(balanceOf[msg.sender] >= _value);\n', '\t\trequire(_value >= 0);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\tfunction unfreeze(uint256 _value) public returns (bool success) {\n', '\t    require(!frozenUser[msg.sender]);\n', '        require(freezeOf[msg.sender] >= _value);\n', '\t\trequire (_value >= 0);\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);\n', '\t\tbalanceOf[msg.sender] = balanceOf[msg.sender].add(_value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function issue(uint amount) public onlyOwner {\n', '        require(_totalSupply + amount > _totalSupply);\n', '        require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);\n', '        _totalSupply += amount;\n', '        balanceOf[msg.sender] += amount;\n', '        emit Issue(amount,now);\n', '    }\n', '\n', '    function redeem(uint amount) public onlyOwner {\n', '        require(_totalSupply >= amount);\n', '        require(balanceOf[msg.sender] >= amount);\n', '        _totalSupply -= amount;\n', '        balanceOf[msg.sender] -= amount;\n', '        emit Redeem(amount,now);\n', '    }\n', '\n', '\tfunction withdrawEther(uint256 amount) public onlyOwner  {\n', '\t    require(isAdminListed(msg.sender));\n', '\t    msg.sender.transfer(amount);\n', '\t}\n', '\n', '\tfunction getETHBalance() public view onlyOwner returns (uint256 _ETHBalance) {\n', '\treturn address(this).balance;\n', '    }\n', '\n', '\tfunction () external payable onlyPayloadSize(2 * 32) { \n', '        emit Received(msg.sender, msg.value,now);\n', '    }\n', '    \n', '    function setEXCHNGAddress (address _exchngSCAddress) public onlyOwner { \n', '        EXCHNG = _exchngSCAddress;\n', '    }\n', '    \n', '    function set_ATMAddress (address _ATMSCAddress) public onlyOwner { \n', '        TOKEN_ATM = _ATMSCAddress;\n', '    }\n', '    \n', '    function set_TokenName (string memory _name,string memory _symbol) public onlyOwner { \n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '    \n', '    function Exchange_Price() public view returns (uint256 actual_Price) {\n', '        return TOKEN_PRICE;\n', '    }\n', '    \n', '    function set_Exchange_Price() public onlyOwner {\n', '        ERC20Interface ERC20Exchng = ERC20Interface(EXCHNG);\n', '        TOKEN_PRICE = ERC20Exchng.Exchange_Price();\n', '    }\n', '}']