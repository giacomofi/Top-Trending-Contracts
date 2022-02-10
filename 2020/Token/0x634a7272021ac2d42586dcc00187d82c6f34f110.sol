['// SPDX-License-Identifier: MIT\n', 'pragma solidity >= 0.6.0 < 0.8.0;\n', '\n', 'interface ERC20 {\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract TokenMine is ERC20 {\n', '    using SafeMath for uint256;\n', '    \n', '    address private deployer;\n', '    string public name = "Aworld Token";\n', '    string public symbol = "AWO";\n', '    uint8 public constant decimals = 4;\n', '    uint256 public totalSupply = 0;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (address => mapping(address=>uint256))  depositRecords;\n', '    mapping (address => bool) public availableTokenMapping; \n', '    mapping (address => bool) public frozenAccountMapping;\n', '    mapping (address => bool) public minterAccountMapping;\n', '    \n', '    event DepositToken(address indexed _from, address indexed _to, uint256 indexed _value);\n', '    event WithdrawToken(address indexed _from, address _contractAddress, uint256 indexed _value);\n', '    event FrozenAccount(address target, bool frozen);\n', '    event MinterAdded(address indexed account);\n', '    event MinterRemoved(address indexed account);\n', '    event MintFinished(address minter, uint256 amount);\n', '    event ClaimFinished(address account, uint256 amount);\n', '    event ExchangeFinished(address account, uint256 fromAmount, address contractAddress, uint256 toAmount);\n', '\n', '    constructor() {\n', '        balances[msg.sender] = totalSupply;\n', '        minterAccountMapping[msg.sender] = true;\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    function balanceOf(address _owner) public override view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public override view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public override returns (bool) {\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public override returns (bool) {\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == deployer);\n', '        _;\n', '    }\n', '    \n', '    function balanceOfToken(address _account, address _contractAddress) public view returns (uint) {\n', '        return depositRecords[_account][_contractAddress];\n', '    }\n', '    \n', '    function enableToken(address _tokenAddress) public onlyOwner {\n', '        availableTokenMapping[_tokenAddress] = true;\n', '    }\n', '    \n', '    function disableToken(address _tokenAddress) public onlyOwner {\n', '        availableTokenMapping[_tokenAddress] = false;\n', '    }\n', '    \n', '    function transferOwnerShip(address _newOwer) public onlyOwner {\n', '        deployer = _newOwer;\n', '    }\n', '\n', '    function addMinter(address account) public onlyOwner {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        minterAccountMapping[account] = true;\n', '    }\n', '\n', '    function removeMinter(address account) public onlyOwner {\n', '        minterAccountMapping[account] = false;\n', '    }\n', '\n', '    function mint(uint amount) public {\n', '        require(minterAccountMapping[msg.sender] == true, "Minter is disabled");\n', '\n', '        totalSupply = totalSupply.add(amount);\n', '        balances[deployer] = balances[deployer].add(amount);\n', '        emit MintFinished(deployer, amount);\n', '    }\n', '\n', '    function claim(address account, uint amount) public {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        require(frozenAccountMapping[account] != true, "Address is disabled");\n', '        require(minterAccountMapping[msg.sender] == true, "Minter is disabled");\n', '\n', '        balances[deployer] = balances[deployer].sub(amount);\n', '        balances[account] = balances[account].add(amount);\n', '        emit ClaimFinished(account, amount);\n', '    }\n', '\n', '    function exchange(address account, uint fromAmount, address contractAddress, uint toAmount) public {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        require(frozenAccountMapping[account] != true, "Address is disabled");\n', '        require(minterAccountMapping[msg.sender] == true, "Minter is disabled");\n', '        \n', '        (bool success, ) = contractAddress.call(abi.encodeWithSignature("transfer(address,uint256)", account, toAmount));\n', '        if(success) {\n', '            totalSupply = totalSupply.sub(fromAmount / 2);\n', '            balances[deployer] = balances[deployer].add(fromAmount);\n', '            balances[account] = balances[account].sub(fromAmount);\n', '            emit ExchangeFinished(account, fromAmount, contractAddress, toAmount);\n', '        }\n', '    }\n', '    \n', '    function depositToken(address contractAddress, uint256 _value) public returns (bool result) {\n', '        require(availableTokenMapping[contractAddress] == true, "Token NOT allow");\n', '        \n', '        (bool success, ) = contractAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), _value));\n', '        if(success) {\n', '            depositRecords[msg.sender][contractAddress] = depositRecords[msg.sender][contractAddress].add(_value);\n', '            emit DepositToken(msg.sender, address(this), _value);\n', '        }\n', '        return success;\n', '    }\n', '    \n', '    function withdrawToken(address contractAddress, uint256 _value) public returns (bool result) {\n', '        require(depositRecords[msg.sender][contractAddress] >= _value);\n', '        require(frozenAccountMapping[msg.sender] != true, "Address is disabled");\n', '        \n', '        (bool success, ) = contractAddress.call(abi.encodeWithSignature("transfer(address,uint256)", msg.sender, _value));\n', '        if(success) {\n', '            depositRecords[msg.sender][contractAddress] -= _value;\n', '            emit WithdrawToken(msg.sender, contractAddress, _value);\n', '        }\n', '        return success;\n', '    }\n', '    \n', '    function transferToMine(address _to, uint256 _value) public returns (bool result) {\n', '        require(availableTokenMapping[msg.sender] == true);\n', '        require(frozenAccountMapping[_to] != true, "Address is disabled");\n', '        depositRecords[_to][msg.sender] = depositRecords[_to][msg.sender].add(_value);\n', '        return true;\n', '    }\n', '    \n', '    function freezeAccount(address target, bool freeze) public onlyOwner returns (bool result) {\n', '        require(target != deployer);\n', '        frozenAccountMapping[target] = freeze;\n', '        return true;\n', '    }\n', '}']