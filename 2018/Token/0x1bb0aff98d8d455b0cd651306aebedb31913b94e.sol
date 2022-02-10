['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0));\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BTHPoint is ERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 internal initialSupply;\n', '    uint256 internal _totalSupply;\n', '    \n', '                                 \n', '    uint256 internal UNLOCK_TERM = 12 * 30 * 24 * 3600; // 1 Year\n', '    uint256 internal _nextUnlockTime;\n', '    uint256 internal _lockupBalance;\n', '\n', '    mapping(address => uint256) internal _balances;    \n', '    mapping(address => mapping(address => uint256)) internal _allowed;\n', '\n', '    function BTHPoint() public {\n', '        name = "Bithumb Coin Point";\n', '        symbol = "BTHP";\n', '        decimals = 18;        \n', '        _nextUnlockTime = now + UNLOCK_TERM;\n', '\n', '        //Total Supply  10,000,000,000\n', '        initialSupply = 10000000000;\n', '        _totalSupply = initialSupply * 10 ** uint(decimals);\n', '        _balances[owner] = 1000000000 * 10 ** uint(decimals);\n', '        _lockupBalance = _totalSupply.sub(_balances[owner]);\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(msg.sender != address(0));\n', '        require(_value <= _balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '        balance = _balances[_holder];\n', '        if(_holder == owner){\n', '            balance = _balances[_holder].add(_lockupBalance);\n', '        }\n', '        return balance;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_from != address(0));\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_value <= _balances[_from]);\n', '        require(_value <= _allowed[_from][msg.sender]);\n', '\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_value > 0);\n', '        _allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _holder, address _spender) public view returns (uint256) {\n', '        return _allowed[_holder][_spender];\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        require(_value <= _balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        _balances[burner] = _balances[burner].sub(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOfLockup() public view returns (uint256) {\n', '        return _lockupBalance;\n', '    }\n', '\n', '    function nextUnlockTime() public view returns (uint256) {\n', '        return _nextUnlockTime;\n', '    }\n', '\n', '    function unlock() public onlyOwner returns(bool) {\n', '        address tokenHolder = msg.sender;\n', '        require(_nextUnlockTime <= now);\n', '        require(_lockupBalance >= 1000000000 * 10 ** uint(decimals));\n', '\n', '        _nextUnlockTime = _nextUnlockTime.add(UNLOCK_TERM);\n', '\n', '        uint256 value = 1000000000 * 10 ** uint(decimals);\n', '\n', '        _lockupBalance = _lockupBalance.sub(value);\n', '        _balances[tokenHolder] = _balances[tokenHolder].add(value);             \n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        uint256 ownerAmount = _balances[owner];\n', '        _balances[owner] = _balances[owner].sub(ownerAmount);\n', '        _balances[newOwner] = _balances[newOwner].add(ownerAmount);\n', '        emit Transfer(owner, newOwner, ownerAmount.add(_lockupBalance));   \n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '             \n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender != address(0));\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BTHPoint is ERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 internal initialSupply;\n', '    uint256 internal _totalSupply;\n', '    \n', '                                 \n', '    uint256 internal UNLOCK_TERM = 12 * 30 * 24 * 3600; // 1 Year\n', '    uint256 internal _nextUnlockTime;\n', '    uint256 internal _lockupBalance;\n', '\n', '    mapping(address => uint256) internal _balances;    \n', '    mapping(address => mapping(address => uint256)) internal _allowed;\n', '\n', '    function BTHPoint() public {\n', '        name = "Bithumb Coin Point";\n', '        symbol = "BTHP";\n', '        decimals = 18;        \n', '        _nextUnlockTime = now + UNLOCK_TERM;\n', '\n', '        //Total Supply  10,000,000,000\n', '        initialSupply = 10000000000;\n', '        _totalSupply = initialSupply * 10 ** uint(decimals);\n', '        _balances[owner] = 1000000000 * 10 ** uint(decimals);\n', '        _lockupBalance = _totalSupply.sub(_balances[owner]);\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(msg.sender != address(0));\n', '        require(_value <= _balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _holder) public view returns (uint256 balance) {\n', '        balance = _balances[_holder];\n', '        if(_holder == owner){\n', '            balance = _balances[_holder].add(_lockupBalance);\n', '        }\n', '        return balance;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_from != address(0));\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_value <= _balances[_from]);\n', '        require(_value <= _allowed[_from][msg.sender]);\n', '\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_value > 0);\n', '        _allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _holder, address _spender) public view returns (uint256) {\n', '        return _allowed[_holder][_spender];\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner returns (bool success) {\n', '        require(_value <= _balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        _balances[burner] = _balances[burner].sub(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOfLockup() public view returns (uint256) {\n', '        return _lockupBalance;\n', '    }\n', '\n', '    function nextUnlockTime() public view returns (uint256) {\n', '        return _nextUnlockTime;\n', '    }\n', '\n', '    function unlock() public onlyOwner returns(bool) {\n', '        address tokenHolder = msg.sender;\n', '        require(_nextUnlockTime <= now);\n', '        require(_lockupBalance >= 1000000000 * 10 ** uint(decimals));\n', '\n', '        _nextUnlockTime = _nextUnlockTime.add(UNLOCK_TERM);\n', '\n', '        uint256 value = 1000000000 * 10 ** uint(decimals);\n', '\n', '        _lockupBalance = _lockupBalance.sub(value);\n', '        _balances[tokenHolder] = _balances[tokenHolder].add(value);             \n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        uint256 ownerAmount = _balances[owner];\n', '        _balances[owner] = _balances[owner].sub(ownerAmount);\n', '        _balances[newOwner] = _balances[newOwner].add(ownerAmount);\n', '        emit Transfer(owner, newOwner, ownerAmount.add(_lockupBalance));   \n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '             \n', '    }\n', '    \n', '}']
