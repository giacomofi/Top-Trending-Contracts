['pragma solidity 0.5.17;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard { \n', '    bool private _notEntered; \n', '    \n', '    function _initReentrancyGuard() internal {\n', '        _notEntered = true;\n', '    } \n', '}\n', '\n', 'contract LexTokenLite is ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    \n', '    address payable public owner;\n', '    address public resolver;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public saleRate;\n', '    uint256 public totalSupply;\n', '    uint256 public totalSupplyCap;\n', '    bytes32 public message;\n', '    bool public forSale;\n', '    bool public initialized;\n', '    bool public transferable; \n', '    \n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    \n', '    mapping(address => mapping(address => uint256)) public allowances;\n', '    mapping(address => uint256) private balances;\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "!owner");\n', '        _;\n', '    }\n', '    \n', '    function init(\n', '        string calldata _name, \n', '        string calldata _symbol, \n', '        uint8 _decimals, \n', '        address payable _owner, \n', '        address _resolver, \n', '        uint256 _ownerSupply, \n', '        uint256 _saleRate, \n', '        uint256 _saleSupply, \n', '        uint256 _totalSupplyCap, \n', '        bytes32 _message, \n', '        bool _forSale, \n', '        bool _transferable\n', '    ) external {\n', '        require(!initialized, "initialized"); \n', '        require(_ownerSupply.add(_saleSupply) <= _totalSupplyCap, "capped");\n', '        \n', '        name = _name; \n', '        symbol = _symbol; \n', '        decimals = _decimals; \n', '        owner = _owner; \n', '        resolver = _resolver;\n', '        saleRate = _saleRate; \n', '        totalSupplyCap = _totalSupplyCap; \n', '        message = _message; \n', '        forSale = _forSale; \n', '        initialized = true; \n', '        transferable = _transferable; \n', '        balances[owner] = balances[owner].add(_ownerSupply);\n', '        balances[address(this)] = balances[address(this)].add(_saleSupply);\n', '        totalSupply = _ownerSupply.add(_saleSupply);\n', '        \n', '        emit Transfer(address(0), owner, _ownerSupply);\n', '        emit Transfer(address(0), address(this), _saleSupply);\n', '        _initReentrancyGuard(); \n', '    }\n', '    \n', '    function() external payable { // SALE \n', '        require(forSale, "!forSale");\n', '        \n', '        (bool success, ) = owner.call.value(msg.value)("");\n', '        require(success, "!transfer");\n', '        uint256 amount = msg.value.mul(saleRate); \n', '        _transfer(address(this), msg.sender, amount);\n', '    } \n', '    \n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        require(amount == 0 || allowances[msg.sender][spender] == 0, "!reset"); \n', '        \n', '        allowances[msg.sender][spender] = amount; \n', '        \n', '        emit Approval(msg.sender, spender, amount); \n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '    \n', '    function balanceResolution(address sender, address recipient, uint256 amount) external returns (bool) {\n', '        require(msg.sender == resolver, "!resolver"); \n', '        \n', '        _transfer(sender, recipient, amount); \n', '        \n', '        return true;\n', '    }\n', '    \n', '    function burn(uint256 amount) external {\n', '        balances[msg.sender] = balances[msg.sender].sub(amount); \n', '        totalSupply = totalSupply.sub(amount); \n', '        \n', '        emit Transfer(msg.sender, address(0), amount);\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        balances[sender] = balances[sender].sub(amount); \n', '        balances[recipient] = balances[recipient].add(amount); \n', '        \n', '        emit Transfer(sender, recipient, amount); \n', '    }\n', '    \n', '    function transfer(address recipient, uint256 amount) external returns (bool) {\n', '        require(transferable, "!transferable"); \n', '        \n', '        _transfer(msg.sender, recipient, amount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferBatch(address[] calldata recipient, uint256[] calldata amount) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        require(recipient.length == amount.length, "!recipient/amount");\n', '        \n', '        for (uint256 i = 0; i < recipient.length; i++) {\n', '            _transfer(msg.sender, recipient[i], amount[i]);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {\n', '        require(transferable, "!transferable");\n', '        \n', '        _transfer(sender, recipient, amount);\n', '        allowances[sender][msg.sender] = allowances[sender][msg.sender].sub(amount); \n', '        \n', '        return true;\n', '    }\n', '    \n', '    /**************\n', '    OWNER FUNCTIONS\n', '    **************/\n', '    function mint(address recipient, uint256 amount) external onlyOwner {\n', '        require(totalSupply.add(amount) <= totalSupplyCap, "capped"); \n', '        \n', '        balances[recipient] = balances[recipient].add(amount); \n', '        totalSupply = totalSupply.add(amount); \n', '        \n', '        emit Transfer(address(0), recipient, amount); \n', '    }\n', '\n', '    function updateMessage(bytes32 _message) external onlyOwner {\n', '        message = _message;\n', '    }\n', '    \n', '    function updateOwner(address payable _owner) external onlyOwner {\n', '        owner = _owner;\n', '    }\n', '    \n', '    function updateResolver(address _resolver) external onlyOwner {\n', '        resolver = _resolver;\n', '    }\n', '    \n', '    function updateSale(uint256 amount, bool _forSale) external onlyOwner {\n', '        require(totalSupply.add(amount) <= totalSupplyCap, "capped");\n', '        \n', '        forSale = _forSale;\n', '        balances[address(this)] = balances[address(this)].add(amount); \n', '        totalSupply = totalSupply.add(amount); \n', '        \n', '        emit Transfer(address(0), address(this), amount);\n', '    }\n', '    \n', '    function updateSaleRate(uint256 _saleRate) external onlyOwner {\n', '        saleRate = _saleRate;\n', '    }\n', '    \n', '    function updateTransferability(bool _transferable) external onlyOwner {\n', '        transferable = _transferable;\n', '    }\n', '}\n', '\n', '/*\n', 'The MIT License (MIT)\n', 'Copyright (c) 2018 Murray Software, LLC.\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', 'contract CloneFactory {\n', '    function createClone(address payable target) internal returns (address payable result) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create(0, clone, 0x37)\n', '        }\n', '    }\n', '}\n', '\n', 'contract LexTokenLiteFactory is CloneFactory {\n', '    address payable public lexDAO;\n', '    address payable public template;\n', '    bytes32 public message;\n', '    \n', '    constructor (address payable _lexDAO, address payable _template, bytes32 _message) public {\n', '        lexDAO = _lexDAO;\n', '        template = _template;\n', '        message = _message;\n', '    }\n', '    \n', '    function LaunchLexTokenLite(\n', '        string memory _name, \n', '        string memory _symbol, \n', '        uint8 _decimals, \n', '        address payable _owner, \n', '        address _resolver,\n', '        uint256 _ownerSupply,\n', '        uint256 _saleRate,\n', '        uint256 _saleSupply,\n', '        uint256 _totalSupplyCap,\n', '        bytes32 _message,\n', '        bool _forSale,\n', '        bool _transferable\n', '    ) payable public returns (address) {\n', '        LexTokenLite lexLite = LexTokenLite(createClone(template));\n', '        \n', '        lexLite.init(\n', '            _name, \n', '            _symbol,\n', '            _decimals, \n', '            _owner, \n', '            _resolver,\n', '            _ownerSupply, \n', '            _saleRate, \n', '            _saleSupply, \n', '            _totalSupplyCap, \n', '            _message, \n', '            _forSale, \n', '            _transferable);\n', '        \n', '        (bool success, ) = lexDAO.call.value(msg.value)("");\n', '        require(success, "!transfer");\n', '\n', '        return address(lexLite);\n', '    }\n', '    \n', '    function updateLexDAO(address payable _lexDAO) external {\n', '        require(msg.sender == lexDAO, "!lexDAO");\n', '        \n', '        lexDAO = _lexDAO;\n', '    }\n', '    \n', '    function updateMessage(bytes32 _message) external {\n', '        require(msg.sender == lexDAO, "!lexDAO");\n', '        \n', '        message = _message;\n', '    }\n', '}']