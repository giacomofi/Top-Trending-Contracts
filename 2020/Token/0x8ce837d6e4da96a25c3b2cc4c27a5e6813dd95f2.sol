['pragma solidity 0.5.17;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard { \n', '    bool private _notEntered; \n', '    \n', '    function _initReentrancyGuard() internal {\n', '        _notEntered = true;\n', '    } \n', '}\n', '\n', 'contract LexTokenLite is ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    \n', '    address payable public owner;\n', '    address public resolver;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public saleRate;\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyCap;\n', '    bytes32 public message;\n', '    bool public forSale;\n', '    bool private initialized;\n', '    bool public transferable; \n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '    mapping(address => uint256) private balances;\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "!owner");\n', '        _;\n', '    }\n', '    \n', '    function init(\n', '        string calldata _name, \n', '        string calldata _symbol, \n', '        uint8 _decimals, \n', '        address payable _owner, \n', '        address _resolver, \n', '        uint256 ownerSupply, \n', '        uint256 _saleRate, \n', '        uint256 saleSupply, \n', '        uint256 _totalSupplyCap, \n', '        bytes32 _message, \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external {\n', '        require(!initialized, "initialized"); \n', '        require(ownerSupply.add(saleSupply) <= _totalSupplyCap, "capped");\n', '        \n', '        name = _name; \n', '        symbol = _symbol; \n', '        decimals = _decimals; \n', '        owner = _owner; \n', '        resolver = _resolver;\n', '        saleRate = _saleRate; \n', '        totalSupplyCap = _totalSupplyCap; \n', '        message = _message; \n', '        forSale = _forSale; \n', '        initialized = true; \n', '        transferable = _transferable; \n', '        balances[owner] = balances[owner].add(ownerSupply);\n', '        balances[address(this)] = balances[address(this)].add(saleSupply);\n', '        totalSupply = ownerSupply.add(saleSupply);\n', '        \n', '        emit Transfer(address(0), owner, ownerSupply);\n', '        emit Transfer(address(0), address(this), saleSupply);\n', '        _initReentrancyGuard(); \n', '    }\n', '    \n', '    function() external payable { // SALE \n', '        require(forSale, "!forSale");\n', '        \n', '        (bool success, ) = owner.call.value(msg.value)("");\n', '        require(success, "!transfer");\n', '        uint256 amount = msg.value.mul(saleRate); \n', '        _transfer(address(this), msg.sender, amount);\n', '    } \n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        require(amount == 0 || allowances[msg.sender][spender] == 0, "!reset"); \n', '        \n', '        allowances[msg.sender][spender] = amount; \n', '        \n', '        emit Approval(msg.sender, spender, amount); \n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '    \n', '    function balanceResolution(address sender, address recipient, uint256 amount) external returns (bool) {\n', '        require(msg.sender == resolver, "!resolver"); \n', '        \n', '        _transfer(sender, recipient, amount); \n', '        \n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 amount) external {\n', '        balances[msg.sender] = balances[msg.sender].sub(amount); \n', '        totalSupply = totalSupply.sub(amount); \n', '        \n', '        emit Transfer(msg.sender, address(0), amount);\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        balances[sender] = balances[sender].sub(amount); \n', '        balances[recipient] = balances[recipient].add(amount); \n', '        \n', '        emit Transfer(sender, recipient, amount); \n', '    }\n', '    \n', '    function transfer(address recipient, uint256 amount) external returns (bool) {\n', '        require(transferable, "!transferable"); \n', '        \n', '        _transfer(msg.sender, recipient, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferBatch(address[] calldata recipient, uint256[] calldata amount) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        require(recipient.length == amount.length, "!recipient/amount");\n', '        \n', '        for (uint256 i = 0; i < recipient.length; i++) {\n', '            _transfer(msg.sender, recipient[i], amount[i]);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        \n', '        _transfer(sender, recipient, amount);\n', '        allowances[sender][msg.sender] = allowances[sender][msg.sender].sub(amount); \n', '        \n', '        return true;\n', '    }\n', '    \n', '    /**************\n', '    OWNER FUNCTIONS\n', '    **************/\n', '    function mint(address recipient, uint256 amount) external onlyOwner {\n', '        require(totalSupply.add(amount) <= totalSupplyCap, "capped"); \n', '        \n', '        balances[recipient] = balances[recipient].add(amount); \n', '        totalSupply = totalSupply.add(amount); \n', '        \n', '        emit Transfer(address(0), recipient, amount); \n', '    }\n', '    \n', '    function mintBatch(address[] calldata recipient, uint256[] calldata amount) external onlyOwner {\n', '        require(recipient.length == amount.length, "!recipient/amount");\n', '        \n', '        for (uint256 i = 0; i < recipient.length; i++) {\n', '            balances[recipient[i]] = balances[recipient[i]].add(amount[i]); \n', '            totalSupply = totalSupply.add(amount[i]);\n', '            emit Transfer(address(0), recipient[i], amount[i]); \n', '        }\n', '        \n', '        require(totalSupply <= totalSupplyCap, "capped");\n', '    }\n', '\n', '    function updateMessage(bytes32 _message) external onlyOwner {\n', '        message = _message;\n', '    }\n', '    \n', '    function updateOwner(address payable _owner) external onlyOwner {\n', '        owner = _owner;\n', '    }\n', '    \n', '    function updateResolver(address _resolver) external onlyOwner {\n', '        resolver = _resolver;\n', '    }\n', '    \n', '    function updateSale(uint256 amount, bool _forSale) external onlyOwner {\n', '        require(totalSupply.add(amount) <= totalSupplyCap, "capped");\n', '        \n', '        forSale = _forSale;\n', '        balances[address(this)] = balances[address(this)].add(amount); \n', '        totalSupply = totalSupply.add(amount); \n', '        \n', '        emit Transfer(address(0), address(this), amount);\n', '    }\n', '    \n', '    function updateSaleRate(uint256 _saleRate) external onlyOwner {\n', '        saleRate = _saleRate;\n', '    }\n', '    \n', '    function updateTransferability(bool _transferable) external onlyOwner {\n', '        transferable = _transferable;\n', '    }\n', '}']