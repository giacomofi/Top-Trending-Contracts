['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '\t\tif (a == 0) {\n', '      \t\treturn 0;\n', '    \t}\n', '\n', '    \tc = a * b;\n', '    \tassert(c / a == b);\n', '    \treturn c;\n', '  \t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    \treturn a / b;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    \tassert(b <= a);\n', '    \treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    \tc = a + b;\n', '    \tassert(c >= a);\n', '    \treturn c;\n', '\t}\n', '\t\n', '\tfunction mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address internal _owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    \n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "you are not the owner!");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    \n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "cannot transfer ownership to ZERO address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface ITokenStore {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns(uint256);\n', '    function transfer(address src, address dest, uint256 amount) external;\n', '    function approve(address owner, address spender, uint256 amount) external;\n', '    function mint(address dest, uint256 amount) external;\n', '    function burn(address dest, uint256 amount) external;\n', '}\n', '\n', '/*\n', '    TokenStore\n', '*/\n', 'contract TokenStore is ITokenStore, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    address private _tokenLogic;\n', '    uint256 private _totalSupply;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    \n', '    constructor(uint256 totalSupply, address holder) public {\n', '        _totalSupply = totalSupply;\n', '        _balances[holder] = totalSupply;\n', '    }\n', '    \n', '    // token logic\n', '    event ChangeTokenLogic(address newTokenLogic);\n', '    \n', '    modifier onlyTokenLogic() {\n', '        require(msg.sender == _tokenLogic, "this method MUST be called by the security&#39;s logic address");\n', '        _;\n', '    }\n', '    \n', '    function tokenLogic() public view returns (address) {\n', '        return _tokenLogic;\n', '    }\n', '    \n', '    function setTokenLogic(ITokenLogic newTokenLogic) public onlyOwner {\n', '        _tokenLogic = newTokenLogic;\n', '        emit ChangeTokenLogic(newTokenLogic);\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function allowance(address owner, address spender) public view returns(uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '    \n', '    function transfer(address src, address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[src] = _balances[src].sub(amount);\n', '        _balances[dest] = _balances[dest].add(amount);\n', '    }\n', '    \n', '    function approve(address owner, address spender, uint256 amount) public onlyTokenLogic {\n', '        _allowed[owner][spender] = amount;\n', '    }\n', '    \n', '    function mint(address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[dest] = _balances[dest].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '    }\n', '    \n', '    function burn(address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[dest] = _balances[dest].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '    }\n', '}\n', '\n', '/*\n', '    TokenLogic\n', '*/\n', 'interface ITokenLogic {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transfer(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value, address owner) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value, address spender) external returns (bool);\n', '    function increaseAllowance(address spender, uint256 addedValue, address owner) external returns (bool);\n', '    function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external returns (bool);\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '\t\tif (a == 0) {\n', '      \t\treturn 0;\n', '    \t}\n', '\n', '    \tc = a * b;\n', '    \tassert(c / a == b);\n', '    \treturn c;\n', '  \t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    \treturn a / b;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    \tassert(b <= a);\n', '    \treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    \tc = a + b;\n', '    \tassert(c >= a);\n', '    \treturn c;\n', '\t}\n', '\t\n', '\tfunction mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address internal _owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor() public {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    \n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "you are not the owner!");\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    \n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "cannot transfer ownership to ZERO address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface ITokenStore {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns(uint256);\n', '    function transfer(address src, address dest, uint256 amount) external;\n', '    function approve(address owner, address spender, uint256 amount) external;\n', '    function mint(address dest, uint256 amount) external;\n', '    function burn(address dest, uint256 amount) external;\n', '}\n', '\n', '/*\n', '    TokenStore\n', '*/\n', 'contract TokenStore is ITokenStore, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    address private _tokenLogic;\n', '    uint256 private _totalSupply;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    \n', '    constructor(uint256 totalSupply, address holder) public {\n', '        _totalSupply = totalSupply;\n', '        _balances[holder] = totalSupply;\n', '    }\n', '    \n', '    // token logic\n', '    event ChangeTokenLogic(address newTokenLogic);\n', '    \n', '    modifier onlyTokenLogic() {\n', '        require(msg.sender == _tokenLogic, "this method MUST be called by the security\'s logic address");\n', '        _;\n', '    }\n', '    \n', '    function tokenLogic() public view returns (address) {\n', '        return _tokenLogic;\n', '    }\n', '    \n', '    function setTokenLogic(ITokenLogic newTokenLogic) public onlyOwner {\n', '        _tokenLogic = newTokenLogic;\n', '        emit ChangeTokenLogic(newTokenLogic);\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function allowance(address owner, address spender) public view returns(uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '    \n', '    function transfer(address src, address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[src] = _balances[src].sub(amount);\n', '        _balances[dest] = _balances[dest].add(amount);\n', '    }\n', '    \n', '    function approve(address owner, address spender, uint256 amount) public onlyTokenLogic {\n', '        _allowed[owner][spender] = amount;\n', '    }\n', '    \n', '    function mint(address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[dest] = _balances[dest].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '    }\n', '    \n', '    function burn(address dest, uint256 amount) public onlyTokenLogic {\n', '        _balances[dest] = _balances[dest].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '    }\n', '}\n', '\n', '/*\n', '    TokenLogic\n', '*/\n', 'interface ITokenLogic {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transfer(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value, address owner) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value, address spender) external returns (bool);\n', '    function increaseAllowance(address spender, uint256 addedValue, address owner) external returns (bool);\n', '    function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external returns (bool);\n', '}']
