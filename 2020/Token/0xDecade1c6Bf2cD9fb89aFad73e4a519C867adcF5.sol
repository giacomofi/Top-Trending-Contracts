['//   __    __ _         _                   _____      _\n', '//  / / /\\ \\ (_)___  __| | ___  _ __ ___   /__   \\___ | | _____ _ __\n', "//  \\ \\/  \\/ / / __|/ _` |/ _ \\| '_ ` _ \\    / /\\/ _ \\| |/ / _ \\ '_ \\\n", '//   \\  /\\  /| \\__ \\ (_| | (_) | | | | | |  / / | (_) |   <  __/ | | |\n', '//    \\/  \\/ |_|___/\\__,_|\\___/|_| |_| |_|  \\/   \\___/|_|\\_\\___|_| |_|\n', '//\n', '//  Author: Grzegorz Kucmierz\n', '//  Source: https://github.com/gkucmierz/wisdom-token\n', '//    Docs: https://gkucmierz.github.io/wisdom-token\n', '//\n', '\n', 'pragma solidity ^0.7.2;\n', '\n', 'contract ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual returns (bool) {\n', '        require(balanceOf[sender] >= amount);\n', '        balanceOf[sender] -= amount;\n', '        balanceOf[recipient] += amount;\n', '        emit Transfer(sender, recipient, amount);\n', '        return true;\n', '    }\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        return _transfer(msg.sender, recipient, amount);\n', '    }\n', '    function allowance(address holder, address spender) public view returns (uint256) {\n', '        return allowed[holder][spender];\n', '    }\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        require(balanceOf[msg.sender] >= amount);\n', '        allowed[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        require(allowed[sender][msg.sender] >= amount);\n', '        _transfer(sender, recipient, amount);\n', '        allowed[sender][msg.sender] -= amount;\n', '        return true;\n', '    }\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed holder, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Ownable {\n', '    address owner;\n', '    address newOwner;\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = msg.sender;\n', '        emit TransferOwnership(msg.sender);\n', '    }\n', '\n', '    event TransferOwnership(address newOwner);\n', '}\n', '\n', 'interface IERC667Receiver {\n', '    function onTokenTransfer(address from, uint256 amount, bytes calldata data) external;\n', '}\n', '\n', 'contract ERC667 is ERC20 {\n', '    function transferAndCall(address recipient, uint amount, bytes calldata data) public returns (bool) {\n', '        bool success = _transfer(msg.sender, recipient, amount);\n', '        if (success){\n', '            IERC667Receiver(recipient).onTokenTransfer(msg.sender, amount, data);\n', '        }\n', '        return success;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = true;\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '\n', '    event Pause();\n', '    event Unpause();\n', '}\n', '\n', 'contract Issuable is ERC20, Ownable {\n', '    bool locked = false;\n', '    modifier whenUnlocked() {\n', '        require(!locked);\n', '        _;\n', '    }\n', '    function issue(address[] memory addr, uint256[] memory amount) public onlyOwner whenUnlocked {\n', '        require(addr.length == amount.length);\n', '        uint8 i;\n', '        uint256 sum = 0;\n', '        for (i = 0; i < addr.length; ++i) {\n', '            balanceOf[addr[i]] = amount[i];\n', '            emit Transfer(address(0x0), addr[i], amount[i]);\n', '            sum += amount[i];\n', '        }\n', '        totalSupply += sum;\n', '    }\n', '    function lock() internal onlyOwner whenUnlocked {\n', '        locked = true;\n', '    }\n', '}\n', '\n', 'contract WisdomToken is ERC667, Pausable, Issuable {\n', '    constructor() {\n', "        name = 'Experty Wisdom Token';\n", "        symbol = 'WIS';\n", '        decimals = 18;\n', '        totalSupply = 0;\n', '    }\n', '    function _transfer(address sender, address recipient, uint256 amount)\n', '        internal whenNotPaused override returns (bool) {\n', '        return super._transfer(sender, recipient, amount);\n', '    }\n', '    function alive(address _newOwner) public {\n', '        lock();\n', '        unpause();\n', '        changeOwner(_newOwner);\n', '    }\n', '}']