['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-20\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface PreSale {\n', '    function userShare(address _useraddress) external view returns (uint256);\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract SIVA is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping (address => bool) claimedPreSaleTokens;\n', '    mapping (address => uint256) public analyticsID;\n', '    mapping (address => uint256) public SIVAadsID;\n', '    mapping (address => uint256) public SIVABusinessID;\n', '    mapping (uint256 => mapping (string => address)) public SIVAMarketingMatrix;\n', '    mapping (uint256 => mapping (string => address)) public SIVAIndexA;\n', '    mapping (uint256 => mapping (string => string)) public SIVAIndexB;\n', '    uint256 private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    string private _url;\n', '    address public _deployer;\n', '    address public presaleContract;\n', '    uint256 public process;\n', '    uint256 public SIVAINDEX;\n', '\n', '    constructor () public {\n', '        _deployer = _msgSender();\n', '        _name = "SIVA";\n', '        _symbol = "SIVA";\n', '        _decimals = 18;\n', '        _url = "https://sivanetwork.eth";\n', '        _totalSupply = 200000000 * 10 ** 18;\n', '        _balances[_deployer] = _totalSupply;\n', '        process = 0;\n', '        SIVAINDEX = 0;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function url() public view returns (string memory) {\n', '        return _url;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function setUrl(string calldata uri) public virtual returns (bool) {\n', '        require (_msgSender() == _deployer, "Only deployer.");\n', '        _url = uri;\n', '        return true;\n', '    }\n', '\n', '    function setPresaleContract(address _contract) public virtual returns (bool) {\n', '        require (_msgSender() == _deployer, "Only deployer.");\n', '        presaleContract = _contract;\n', '        return true;\n', '    }\n', '\n', '    function setName(string calldata cname) public virtual returns (bool) {\n', '        require (_msgSender() == _deployer, "Only deployer.");\n', '        _name = cname;\n', '        return true;\n', '    }\n', '\n', '    function generateCard() public virtual returns (bool) {\n', '        require (_msgSender() != address(0), "No Zero address submission.");\n', '        analyticsID[_msgSender()] = process;\n', '        SIVAadsID[_msgSender()] = process;\n', '        SIVABusinessID[_msgSender()] = process;\n', '        process += 1;\n', '        return true;\n', '    }\n', '\n', '    function generateMarketingMatrix(string calldata _metadata, string calldata _description) public virtual returns (bool) {\n', '        require (_msgSender() != address(0), "No Zero address submission.");\n', '        SIVAMarketingMatrix[SIVAINDEX][_metadata] = _msgSender();\n', '        SIVAIndexA[SIVAINDEX][_metadata] = _msgSender();\n', '        SIVAIndexB[SIVAINDEX][_metadata] = _description;\n', '        SIVAINDEX += 1;\n', '        return true;\n', '    }\n', '\n', '    function claimPresaleTokens() public virtual returns (bool) {\n', '        require(_msgSender() != address(0), "No request from the zero address");\n', '        require(claimedPreSaleTokens[_msgSender()] == false, "Unable");\n', '        _transfer(address(this), _msgSender(), PreSale(presaleContract).userShare(_msgSender()));\n', '        claimedPreSaleTokens[_msgSender()] = true;\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}']