['pragma solidity 0.5.17;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract LexToken {\n', '    using SafeMath for uint256;\n', '    address payable public owner;\n', '    address public resolver;\n', '    uint8 public decimals;\n', '    uint256 public saleRate;\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyCap;\n', '    string public message;\n', '    string public name;\n', '    string public symbol;\n', '    bool public forSale;\n', '    bool private initialized;\n', '    bool public transferable; \n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event BalanceResolution(string indexed details);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '    mapping(address => uint256) public balanceOf;\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "!owner");\n', '        _;\n', '    }\n', '    \n', '    function init(\n', '        address payable _owner,\n', '        address _resolver,\n', '        uint8 _decimals, \n', '        uint256 ownerSupply, \n', '        uint256 _saleRate, \n', '        uint256 saleSupply, \n', '        uint256 _totalSupplyCap,\n', '        string calldata _message, \n', '        string calldata _name, \n', '        string calldata _symbol,  \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external {\n', '        require(!initialized, "initialized"); \n', '        require(ownerSupply.add(saleSupply) <= _totalSupplyCap, "capped");\n', '        owner = _owner; \n', '        resolver = _resolver;\n', '        decimals = _decimals; \n', '        saleRate = _saleRate; \n', '        totalSupplyCap = _totalSupplyCap; \n', '        message = _message; \n', '        name = _name; \n', '        symbol = _symbol;  \n', '        forSale = _forSale; \n', '        initialized = true; \n', '        transferable = _transferable; \n', '        balanceOf[owner] = ownerSupply;\n', '        balanceOf[address(this)] = saleSupply;\n', '        totalSupply = ownerSupply.add(saleSupply);\n', '        emit Transfer(address(0), owner, ownerSupply);\n', '        emit Transfer(address(0), address(this), saleSupply);\n', '    }\n', '    \n', '    function() external payable { // SALE \n', '        require(forSale, "!forSale");\n', '        (bool success, ) = owner.call.value(msg.value)("");\n', '        require(success, "!transfer");\n', '        uint256 amount = msg.value.mul(saleRate); \n', '        _transfer(address(this), msg.sender, amount);\n', '    } \n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        require(amount == 0 || allowances[msg.sender][spender] == 0, "!reset"); \n', '        allowances[msg.sender][spender] = amount; \n', '        emit Approval(msg.sender, spender, amount); \n', '        return true;\n', '    }\n', '\n', '    function balanceResolution(address from, address to, uint256 amount, string calldata details) external { // resolve disputed or lost balances\n', '        require(msg.sender == resolver, "!resolver"); \n', '        _transfer(from, to, amount); \n', '        emit BalanceResolution(details);\n', '    }\n', '    \n', '    function burn(uint256 amount) external {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount); \n', '        totalSupply = totalSupply.sub(amount); \n', '        emit Transfer(msg.sender, address(0), amount);\n', '    }\n', '    \n', '    function _transfer(address from, address to, uint256 amount) internal {\n', '        balanceOf[from] = balanceOf[from].sub(amount); \n', '        balanceOf[to] = balanceOf[to].add(amount); \n', '        emit Transfer(from, to, amount); \n', '    }\n', '    \n', '    function transfer(address to, uint256 amount) public returns (bool) {\n', '        require(transferable, "!transferable"); \n', '        _transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferBatch(address[] calldata to, uint256[] calldata amount) external {\n', '        require(to.length == amount.length, "!to/amount");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            transfer(to[i], amount[i]);\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        allowances[from][msg.sender] = allowances[from][msg.sender].sub(amount); \n', '        _transfer(from, to, amount);\n', '        return true;\n', '    }\n', '    \n', '    /**************\n', '    OWNER FUNCTIONS\n', '    **************/\n', '    function mint(address to, uint256 amount) public onlyOwner {\n', '        require(totalSupply.add(amount) <= totalSupplyCap, "capped"); \n', '        balanceOf[to] = balanceOf[to].add(amount); \n', '        totalSupply = totalSupply.add(amount); \n', '        emit Transfer(address(0), to, amount); \n', '    }\n', '    \n', '    function mintBatch(address[] calldata to, uint256[] calldata amount) external onlyOwner {\n', '        require(to.length == amount.length, "!to/amount");\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            mint(to[i], amount[i]);\n', '        }\n', '    }\n', '    \n', '    function updateGovernance(address payable _owner, address _resolver, string calldata _message) external onlyOwner {\n', '        owner = _owner;\n', '        resolver = _resolver;\n', '        message = _message;\n', '    }\n', '\n', '    function updateSale(uint256 amount, uint256 _saleRate, bool _forSale) external onlyOwner {\n', '        saleRate = _saleRate;\n', '        forSale = _forSale;\n', '        mint(address(this), amount);\n', '    }\n', '    \n', '    function updateTransferability(bool _transferable) external onlyOwner {\n', '        transferable = _transferable;\n', '    }\n', '}']