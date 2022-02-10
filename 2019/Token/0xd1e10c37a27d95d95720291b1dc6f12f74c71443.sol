['pragma solidity 0.5.4;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;       \n', '    }       \n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    modifier onlyNewOwner() {\n', '        require(msg.sender == newOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public onlyNewOwner returns(bool) {\n', '        emit OwnershipTransferred(owner, newOwner);        \n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Whitelist is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => bool) public whitelist;\n', '    \n', '    event AddWhiteListAddress(address indexed _address);\n', '    event RemoveWhiteListAddress(address indexed _address);\n', '\n', '\n', '    constructor() public {\n', '        whitelist[owner] = true;\n', '    }\n', '    \n', '    function AddWhitelist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        require(whitelist[account] == false);\n', '        require(account != address(this));\n', '        whitelist[account] = true;\n', '        emit AddWhiteListAddress(account);\n', '        return true;\n', '    }\n', '\n', '    function RemoveWhiltelist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        require(whitelist[account] == true);\n', '        require(account != owner);\n', '        whitelist[account] = false;\n', '        emit RemoveWhiteListAddress(account);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable, Whitelist {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(whitelist[msg.sender] == true || !paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract Blacklist is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => bool) public blacklist;\n', '    \n', '    event AddBlackListAddress(address indexed _address);\n', '    event RemoveBlackListAddress(address indexed _address);\n', '\n', '\n', '    constructor() public {\n', '        \n', '    }\n', '    \n', '    function AddBlacklist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        require(blacklist[account] == false);\n', '        require(account != address(this));\n', '        require(account != owner);\n', '\n', '        blacklist[account] = true;\n', '        emit AddBlackListAddress(account);\n', '        return true;\n', '    }\n', '\n', '    function RemoveBlacklist(address account) public onlyOwner returns(bool) {\n', '        require(account != address(0));\n', '        require(blacklist[account] == true);\n', '        blacklist[account] = false;\n', '        emit RemoveBlackListAddress(account);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CosmoCoin is ERC20, Ownable, Pausable, Blacklist{\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    \n', '    string private _name = "CosmoCoin";\n', '    string private _symbol = "COSM";\n', '    uint8 private _decimals = 18;\n', '    uint256 private totalTokenSupply;\n', '    \n', '    event Mint(address indexed to, uint256 value);\n', '    event Burn(address indexed from, address indexed at, uint256 value);\n', '    \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    constructor(uint256 _totalSupply) public {\n', '        require(_totalSupply > 0);\n', '        totalTokenSupply = _totalSupply.mul(10 ** uint(_decimals));\n', '        balances[msg.sender] = totalTokenSupply;\n', '        emit Transfer(address(0), msg.sender, totalTokenSupply);\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return totalTokenSupply;\n', '    }\n', '    \n', '    function balanceOf(address _who) public view returns(uint256) {\n', '        return balances[_who];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) public whenNotPaused returns(bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_amount > 0);\n', '        require(_amount <= balances[msg.sender]);\n', '        require(blacklist[msg.sender] == false);\n', '        require(blacklist[_to] == false);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) public whenNotPaused returns(bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        require(blacklist[_from] == false);\n', '        require(blacklist[_to] == false);\n', '        require(blacklist[msg.sender] == false);\n', '\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns(bool) {\n', "        // reduce spender's allowance to 0 then set desired value after to avoid race condition\n", '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function () payable external{\n', '        revert();\n', '    }\n', '    \n', '    function burn(address _address, uint256 _value) external whenNotPaused {\n', '        require(_value <= balances[_address]);\n', '        require((whitelist[msg.sender] == true && _address == msg.sender) || (msg.sender == owner));\n', '        balances[_address] = balances[_address].sub(_value);\n', '        totalTokenSupply = totalTokenSupply.sub(_value);\n', '        emit Burn(msg.sender, _address, _value);\n', '        emit Transfer(_address, address(0), _value);\n', '    }\n', '    \n', '    function mintTokens(address _beneficiary, uint256 _value) external onlyOwner {\n', '        require(_beneficiary != address(0));\n', '        require(blacklist[_beneficiary] == false);\n', '        require(_value > 0);\n', '        balances[_beneficiary] = balances[_beneficiary].add(_value);\n', '        totalTokenSupply = totalTokenSupply.add(_value);\n', '        emit Mint(_beneficiary, _value);\n', '        emit Transfer(address(0), _beneficiary, _value);\n', '    }\n', '}']