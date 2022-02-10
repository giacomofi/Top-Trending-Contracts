['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.7.2;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed from, address indexed _to);\n', '\n', '    constructor(address _owner) {\n', '        owner = _owner;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) external onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() external {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'abstract contract Pausable is Owned {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '      require(!paused, "all transaction has been paused");\n', '      _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '      require(paused, "transaction is current opened");\n', '      _;\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused external {\n', '      paused = true;\n', '      emit Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused external {\n', '      paused = false;\n', '      emit Unpause();\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    \n', '    function balanceOf(address account) external view returns (uint256);\n', '    \n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    \n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'abstract contract ERC20 is IERC20, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public override view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public override returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    function _transferFrom(address sender, address recipient, uint256 amount) internal whenNotPaused returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '}\n', '\n', 'contract Fast500Token is ERC20 {\n', '\n', '    using SafeMath for uint256;\n', '    string  public  name;\n', '    string  public  symbol;\n', '    uint8   public decimals;\n', '\n', '    uint256 public totalMinted;\n', '    uint256 public totalBurnt;\n', '\n', '    constructor(string memory _name, string memory _symbol) Owned(msg.sender) {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = 18;\n', '        _mint(msg.sender, 500 ether);\n', '        totalMinted = totalSupply();\n', '        totalBurnt = 0;\n', '    }\n', '    \n', '    function burn(uint256 _amount) external whenNotPaused returns (bool) {\n', '       super._burn(msg.sender, _amount);\n', '       totalBurnt = totalBurnt.add(_amount);\n', '       return true;\n', '   }\n', '\n', '    function transfer(address _recipient, uint256 _amount) public override whenNotPaused returns (bool) {\n', '        if(totalSupply() <= 100 ether) {\n', '            super._transfer(msg.sender, _recipient, _amount);\n', '            return true;\n', '        }\n', '        \n', '        uint _amountToBurn = _amount.mul(8).div(100);\n', '        _burn(msg.sender, _amountToBurn);\n', '        totalBurnt = totalBurnt.add(_amountToBurn);\n', '        uint _unBurntToken = _amount.sub(_amountToBurn);\n', '        super._transfer(msg.sender, _recipient, _unBurntToken);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _sender, address _recipient, uint256 _amount) public override whenNotPaused returns (bool) {\n', '        super._transferFrom(_sender, _recipient, _amount);\n', '        return true;\n', '    }\n', '    \n', '  // Removed mint function for onlyOwner\n', '    \n', '    receive() external payable {\n', '        uint _amount = msg.value;\n', '        msg.sender.transfer(_amount);\n', '    }\n', '}']