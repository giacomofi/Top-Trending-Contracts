['pragma solidity ^0.4.8;\n', '\n', '//Kings Distributed Systems\n', '//ERC20 Compliant DCC Token\n', 'contract DCCToken {\n', '    string public constant name     = "Distributed Compute Credits";\n', '    string public constant symbol   = "DCC";\n', '    uint8  public constant decimals = 18;\n', '\n', '    uint256 public totalSupply      = 0;\n', '    \n', '    bool    public frozen           = false;\n', '    \n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => bool) admins;\n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAdmin() {\n', '        if (!admins[msg.sender]) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', ' \n', '    event Transfer(address indexed from,  address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    // Constructor\n', '    function DCCToken() {\n', '        owner = msg.sender;\n', '        admins[msg.sender] = true;\n', '    }\n', '    \n', '    function addAdmin (address admin) onlyOwner {\n', '        admins[admin] = true;\n', '    }\n', '    \n', '    function removeAdmin (address admin) onlyOwner {\n', '        admins[admin] = false;\n', '    }\n', '    \n', '    function totalSupply() external constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address owner) external constant returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '    \n', '    // Open support ticket to prove transfer mistake to unusable address.\n', '    // Not to be used to dispute transfers. Only for trapped tokens.\n', '    function recovery(address from, address to, uint256 amount) onlyAdmin external {\n', '        assert(balances[from] >= amount);\n', '        assert(amount > 0);\n', '    \n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        Transfer(from, this, amount);\n', '        Transfer(this, to, amount);\n', '    }\n', ' \n', '    function approve(address spender, uint256 amount) external returns (bool){\n', '        allowed[msg.sender][spender] = amount;\n', '        Approval(msg.sender, spender, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool) {\n', '        if(frozen\n', '        || amount == 0\n', '        || amount > allowed[from][msg.sender]\n', '        || amount > balances[from]\n', '        || amount + balances[to] < balances[to]){\n', '            return false;\n', '        }\n', '        \n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        allowed[from][msg.sender] -= amount;\n', '        Transfer(from, to, amount);\n', '        \n', '        return true;\n', '    }\n', ' \n', '    function allowance(address owner, address spender) external constant returns (uint256) {\n', '        return allowed[owner][spender];\n', '    }\n', ' \n', '    function create(address to, uint256 amount) onlyAdmin external returns (bool) {\n', '        if (amount == 0\n', '        || balances[to] + amount < balances[to]){\n', '            return false;\n', '        }\n', '        \n', '        totalSupply += amount;\n', '        balances[to] += amount;\n', '        Transfer(this, to, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function destroy(address from, uint256 amount) onlyAdmin external returns (bool) {\n', '        if(amount == 0\n', '        || balances[from] < amount){\n', '            return false;\n', '        }\n', '        \n', '        balances[from] -= amount;\n', '        totalSupply -= amount;\n', '        Transfer(from, this, amount);\n', '        \n', '        return true;\n', '    }\n', ' \n', '    function transfer(address to, uint256 amount) external returns (bool) {\n', '        if (frozen\n', '        || amount == 0\n', '        || balances[msg.sender] < amount\n', '        || balances[to] + amount < balances[to]){\n', '            return false;\n', '        }\n', '    \n', '        balances[msg.sender] -= amount;\n', '        balances[to] += amount;\n', '        Transfer(msg.sender, to, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function freeze () onlyAdmin external {\n', '        frozen = true;\n', '    }\n', '    \n', '    function unfreeze () onlyAdmin external {\n', '        frozen = false;\n', '    }\n', '    \n', '    // Do not transfer ether to this contract.\n', '    function () payable {\n', '        throw;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', '//Kings Distributed Systems\n', '//ERC20 Compliant DCC Token\n', 'contract DCCToken {\n', '    string public constant name     = "Distributed Compute Credits";\n', '    string public constant symbol   = "DCC";\n', '    uint8  public constant decimals = 18;\n', '\n', '    uint256 public totalSupply      = 0;\n', '    \n', '    bool    public frozen           = false;\n', '    \n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', '    \n', '    mapping(address => bool) admins;\n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAdmin() {\n', '        if (!admins[msg.sender]) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', ' \n', '    event Transfer(address indexed from,  address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    // Constructor\n', '    function DCCToken() {\n', '        owner = msg.sender;\n', '        admins[msg.sender] = true;\n', '    }\n', '    \n', '    function addAdmin (address admin) onlyOwner {\n', '        admins[admin] = true;\n', '    }\n', '    \n', '    function removeAdmin (address admin) onlyOwner {\n', '        admins[admin] = false;\n', '    }\n', '    \n', '    function totalSupply() external constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address owner) external constant returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '    \n', '    // Open support ticket to prove transfer mistake to unusable address.\n', '    // Not to be used to dispute transfers. Only for trapped tokens.\n', '    function recovery(address from, address to, uint256 amount) onlyAdmin external {\n', '        assert(balances[from] >= amount);\n', '        assert(amount > 0);\n', '    \n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        Transfer(from, this, amount);\n', '        Transfer(this, to, amount);\n', '    }\n', ' \n', '    function approve(address spender, uint256 amount) external returns (bool){\n', '        allowed[msg.sender][spender] = amount;\n', '        Approval(msg.sender, spender, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool) {\n', '        if(frozen\n', '        || amount == 0\n', '        || amount > allowed[from][msg.sender]\n', '        || amount > balances[from]\n', '        || amount + balances[to] < balances[to]){\n', '            return false;\n', '        }\n', '        \n', '        balances[from] -= amount;\n', '        balances[to] += amount;\n', '        allowed[from][msg.sender] -= amount;\n', '        Transfer(from, to, amount);\n', '        \n', '        return true;\n', '    }\n', ' \n', '    function allowance(address owner, address spender) external constant returns (uint256) {\n', '        return allowed[owner][spender];\n', '    }\n', ' \n', '    function create(address to, uint256 amount) onlyAdmin external returns (bool) {\n', '        if (amount == 0\n', '        || balances[to] + amount < balances[to]){\n', '            return false;\n', '        }\n', '        \n', '        totalSupply += amount;\n', '        balances[to] += amount;\n', '        Transfer(this, to, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function destroy(address from, uint256 amount) onlyAdmin external returns (bool) {\n', '        if(amount == 0\n', '        || balances[from] < amount){\n', '            return false;\n', '        }\n', '        \n', '        balances[from] -= amount;\n', '        totalSupply -= amount;\n', '        Transfer(from, this, amount);\n', '        \n', '        return true;\n', '    }\n', ' \n', '    function transfer(address to, uint256 amount) external returns (bool) {\n', '        if (frozen\n', '        || amount == 0\n', '        || balances[msg.sender] < amount\n', '        || balances[to] + amount < balances[to]){\n', '            return false;\n', '        }\n', '    \n', '        balances[msg.sender] -= amount;\n', '        balances[to] += amount;\n', '        Transfer(msg.sender, to, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function freeze () onlyAdmin external {\n', '        frozen = true;\n', '    }\n', '    \n', '    function unfreeze () onlyAdmin external {\n', '        frozen = false;\n', '    }\n', '    \n', '    // Do not transfer ether to this contract.\n', '    function () payable {\n', '        throw;\n', '    }\n', '}']