['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-30\n', '*/\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '// Ownable contract from open zepplin\n', '\n', 'contract Ownable {\n', '    \n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () public {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, _newOwner);\n', '        _owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '// safemath library for addition and subtraction\n', '\n', 'library SafeMath {\n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// erc20 interface\n', '\n', 'interface ERC20{\n', '    \n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address _tokenOwner) external view returns (uint256);\n', '    function allowance(address _tokenOwner, address _spender) external view returns (uint256);\n', '    function transfer(address _to, uint256 _tokens) external returns (bool);\n', '    function approve(address _spender, uint256 _tokens)  external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool);\n', '    \n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    \n', '}\n', '\n', '\n', '// contract\n', '\n', 'contract ByourBank is Ownable, ERC20{\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    string _name;\n', '    string  _symbol;\n', '    uint256 _totalSupply;\n', '    uint256 _decimal;\n', '    \n', '    mapping(address => uint256) _balances;\n', '    mapping(address => mapping (address => uint256)) _allowances;\n', '    \n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    \n', '    constructor() public {\n', '        _name = "B your Bank";\n', '        _symbol = "BYB";\n', '        _decimal = 18;\n', '        _totalSupply = 250000 * 10 ** _decimal;\n', '        _balances[msg.sender] = _totalSupply;\n', '    }\n', '    \n', '    \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    \n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    \n', '    function decimals() public view returns (uint256) {\n', '        return _decimal;\n', '    }\n', '    \n', '    function totalSupply() external view  override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _tokenOwner) external view override returns (uint256) {\n', '        return _balances[_tokenOwner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _tokens) external override returns (bool) {\n', '        _transfer(msg.sender, _to, _tokens);\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address _sender, address _recipient, uint256 _amount) internal {\n', '        require(_sender != address(0), "ERC20: transfer from the zero address");\n', '        require(_recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[_sender] = _balances[_sender].safeSub(_amount);\n', '        _balances[_recipient] = _balances[_recipient].safeAdd(_amount);\n', '        emit Transfer(_sender, _recipient, _amount);\n', '    }\n', '    \n', '    function allowance(address _tokenOwner, address _spender) external view override returns (uint256) {\n', '        return _allowances[_tokenOwner][_spender];\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _tokens) external override returns (bool) {\n', '        _approve(msg.sender, _spender, _tokens);\n', '        return true;\n', '    }\n', '    \n', '    function _approve(address _owner, address _spender, uint256 _value) internal {\n', '        require(_owner != address(0), "ERC20: approve from the zero address");\n', '        require(_spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[_owner][_spender] = _value;\n', '        emit Approval(_owner, _spender, _value);\n', '    }\n', '    \n', '    \n', '    function transferFrom(address _from, address _to, uint256 _tokens) external override returns (bool) {\n', '        _transfer(_from, _to, _tokens);\n', '        _approve(_from, msg.sender, _allowances[_from][msg.sender].safeSub(_tokens));\n', '        return true;\n', '    }\n', "    // don't accept eth\n", '    receive () external payable {\n', '        revert();\n', '    }\n', '\n', '}']