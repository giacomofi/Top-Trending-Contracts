['pragma solidity 0.4.21;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 is owned {\n', '    address public deployer;\n', '\n', '    string public name ="Universe-USD";\n', '    string public symbol = "UUSD";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function TokenERC20() public {\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\t\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract MyAdvancedToken is TokenERC20 {\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function MyAdvancedToken() TokenERC20() public {}\n', '\n', '     function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        uint tempSupply = totalSupply;\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        require(totalSupply >= tempSupply);\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function () payable public {\n', '        require(false);\n', '    }\n', '\n', '}\n', '\n', 'contract UUSD is MyAdvancedToken {\n', '    mapping(address => uint) public lockdate;\n', '    mapping(address => uint) public lockTokenBalance;\n', '\n', '    event LockToken(address account, uint amount, uint unixtime);\n', '\n', '    function UUSD() MyAdvancedToken() public {}\n', '    function getLockBalance(address account) internal returns(uint) {\n', '        if(now >= lockdate[account]) {\n', '            lockdate[account] = 0;\n', '            lockTokenBalance[account] = 0;\n', '        }\n', '        return lockTokenBalance[account];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        uint usableBalance = balanceOf[_from] - getLockBalance(_from);\n', '        require(balanceOf[_from] >= usableBalance);\n', '        require(_to != 0x0);\n', '        require(usableBalance >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {\n', '        require(unixtime >= lockdate[account]);\n', '        require(unixtime >= now);\n', '        if(balanceOf[account] >= amount) {\n', '            lockdate[account] = unixtime;\n', '            lockTokenBalance[account] = amount;\n', '            emit LockToken(account, amount, unixtime);\n', '        }\n', '    }\n', '\n', '    function lockTokenDays(address account, uint amount, uint _days) public {\n', '        uint unixtime = _days * 1 days + now;\n', '        lockTokenToDate(account, amount, unixtime);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);\n', '        require(balanceOf[msg.sender] >= usableBalance);\n', '        require(usableBalance >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value; \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity 0.4.21;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 is owned {\n', '    address public deployer;\n', '\n', '    string public name ="Universe-USD";\n', '    string public symbol = "UUSD";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function TokenERC20() public {\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\t\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract MyAdvancedToken is TokenERC20 {\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    function MyAdvancedToken() TokenERC20() public {}\n', '\n', '     function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        uint tempSupply = totalSupply;\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        require(totalSupply >= tempSupply);\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function () payable public {\n', '        require(false);\n', '    }\n', '\n', '}\n', '\n', 'contract UUSD is MyAdvancedToken {\n', '    mapping(address => uint) public lockdate;\n', '    mapping(address => uint) public lockTokenBalance;\n', '\n', '    event LockToken(address account, uint amount, uint unixtime);\n', '\n', '    function UUSD() MyAdvancedToken() public {}\n', '    function getLockBalance(address account) internal returns(uint) {\n', '        if(now >= lockdate[account]) {\n', '            lockdate[account] = 0;\n', '            lockTokenBalance[account] = 0;\n', '        }\n', '        return lockTokenBalance[account];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        uint usableBalance = balanceOf[_from] - getLockBalance(_from);\n', '        require(balanceOf[_from] >= usableBalance);\n', '        require(_to != 0x0);\n', '        require(usableBalance >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {\n', '        require(unixtime >= lockdate[account]);\n', '        require(unixtime >= now);\n', '        if(balanceOf[account] >= amount) {\n', '            lockdate[account] = unixtime;\n', '            lockTokenBalance[account] = amount;\n', '            emit LockToken(account, amount, unixtime);\n', '        }\n', '    }\n', '\n', '    function lockTokenDays(address account, uint amount, uint _days) public {\n', '        uint unixtime = _days * 1 days + now;\n', '        lockTokenToDate(account, amount, unixtime);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);\n', '        require(balanceOf[msg.sender] >= usableBalance);\n', '        require(usableBalance >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value; \n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']
