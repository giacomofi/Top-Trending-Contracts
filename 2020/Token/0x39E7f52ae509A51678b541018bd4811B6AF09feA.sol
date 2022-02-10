['/**\n', ' *Submitted for verification at Etherscan.io on 2020-08-16\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '\n', '    mapping (address => uint) private _balances;\n', '\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract Biden is ERC20, ERC20Detailed  {\n', '\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint;\n', '\n', '    address public governance;\n', '    mapping (address => bool) public minters;\n', '\n', '    event LogRebase(uint256 indexed epoch, uint256 totalSupply);\n', '\n', '    modifier validRecipient(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    uint256 public unlockDate = 1604448000;\n', '    uint256 private constant DECIMALS = 18;\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 50000 * 10**DECIMALS;\n', '\n', '    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);\n', '\n', '    uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 private _gonsPerFragment;\n', '    mapping(address => uint256) private _gonBalances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowedFragments;\n', '\n', '    constructor () public ERC20Detailed("Yearn Joe", "yJOE", 18) {\n', '        governance = msg.sender;\n', '        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;\n', '        _gonBalances[governance] = TOTAL_GONS;\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit Transfer(address(0x0), governance, _totalSupply);\n', '    }\n', '\n', '    function setGovernance(address _governance) public {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '\n', '    function rebaseDown(uint256 epoch, uint256 supplyDelta)\n', '        external\n', '        returns (uint256)\n', '    {\n', '        require(msg.sender == governance, "!governance");\n', '        require(now >= unlockDate);\n', '\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(epoch, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '         _totalSupply = _totalSupply.sub(supplyDelta);\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit LogRebase(epoch, _totalSupply);\n', '        return _totalSupply;\n', '    }\n', '\n', '    function rebaseUp(uint256 epoch, uint256 supplyDelta)\n', '        external\n', '        returns (uint256)\n', '    {\n', '        require(msg.sender == governance, "!governance");\n', '        require(now >= unlockDate);\n', '\n', '        if (supplyDelta == 0) {\n', '            emit LogRebase(epoch, _totalSupply);\n', '            return _totalSupply;\n', '        }\n', '\n', '        _totalSupply = _totalSupply.add(uint256(supplyDelta));\n', '        \n', '        if (_totalSupply > MAX_SUPPLY) {\n', '            _totalSupply = MAX_SUPPLY;\n', '        }\n', '\n', '        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);\n', '\n', '        emit LogRebase(epoch, _totalSupply);\n', '        return _totalSupply;\n', '    }\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _gonBalances[who].div(_gonsPerFragment);\n', '    }\n', '\n', '    function transfer(address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner_, address spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public\n', '        validRecipient(to)\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '\n', '        uint256 gonValue = value.mul(_gonsPerFragment);\n', '        _gonBalances[from] = _gonBalances[from].sub(gonValue);\n', '        _gonBalances[to] = _gonBalances[to].add(gonValue);\n', '        emit Transfer(from, to, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =\n', '            _allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '}']