['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-31\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '    \n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address tokenOwner) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '    address private owner = msg.sender;\n', '    \n', '    function getOwner() public view returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "ERC20: permission denied");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner returns (bool) {\n', '        owner = newOwner;\n', '        return true;\n', '    }\n', '    \n', '}\n', '\n', 'contract Feeable is Ownable {\n', '    \n', '    bool public feeOn = true;\n', '    address public feeTo = msg.sender;\n', '    uint256 public feePoint = 6;\n', '    uint256 public feeRatio = 1000;\n', '\n', '    function setFeeTo(address _feeTo) public onlyOwner returns (address) {\n', '        feeTo = _feeTo;\n', '        return feeTo;\n', '    }\n', '    \n', '    function setFeeOn(bool _feeOn) public onlyOwner returns (bool) {\n', '        feeOn = _feeOn;\n', '        return feeOn;\n', '    }\n', '    \n', '    function setFeePoint(uint256 _feePoint) public onlyOwner returns (uint256) {\n', '        feePoint = _feePoint;\n', '        return feePoint;\n', '    }\n', '    \n', '    function setFeeRatio(uint256 _feeRatio) public onlyOwner returns (uint256) {\n', '        feeRatio = _feeRatio;\n', '        return feePoint;\n', '    }\n', '    \n', '}\n', '\n', 'contract OxCoinToken is IERC20, Feeable {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name = "OxCoin Token";\n', '    string public symbol = "OXC";\n', '    uint256 public decimals = 8;\n', '    uint256 private _totalSupply = 10 ** 10 * (10 ** 8);\n', '    \n', '    mapping(address => uint256) private balances;\n', '    mapping(address => mapping(address => uint256)) private allowed;\n', '    \n', '    constructor() {\n', '        balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function mint(address tokenOwner, uint256 amount) public onlyOwner returns (uint256) {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        balances[tokenOwner] = balances[tokenOwner].add(amount);\n', '        emit Transfer(address(0), tokenOwner, amount);\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    function burn(address tokenOwner, uint256 amount) public returns (uint256) {\n', '        require(msg.sender == getOwner() || msg.sender == tokenOwner, "ERC20: permission denied");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        balances[tokenOwner] = balances[tokenOwner].sub(amount);\n', '        emit Transfer(tokenOwner, address(0), amount);\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    function airDrop(address[] memory recipients, uint256[] memory amount) public {\n', '        require(recipients.length > 0 && amount.length > 0, "ERC20: The airdrop need required an available address and amount");\n', '        require(amount.length >= recipients.length, "ERC20: The amount length of the airdrop array cannot be less than the address length");\n', '        \n', '        uint256 totalAmount = 0;\n', '        for(uint256 n = 0; n < amount.length; n++) {\n', '            totalAmount = totalAmount.add(amount[n]);\n', '        }\n', '        \n', '        require(balances[msg.sender] >= totalAmount, "ERC20: airdrops transfer sender amount exceeds balance");\n', '        for (uint256 i = 0; i < recipients.length; i++) {\n', '            _transfer(msg.sender, recipients[i], amount[i]);\n', '        }\n', '    }\n', '    \n', '    function totalSupply() public override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address tokenOwner) public override view returns (uint256) {\n', '        return balances[tokenOwner];    \n', '    }\n', '    \n', '    function allowance(address tokenOwner, address spender) public override view returns (uint) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, allowed[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(balances[sender] >= amount, "ERC20: transfer sender amount exceeds balance");\n', '        \n', '        uint256 fee = 0;\n', '        if (feeOn) {\n', '            fee = amount.mul(feePoint).div(feeRatio);\n', '            if (fee == 0) fee = 1; //Minimum amount 0.00000001 OXC\n', '            balances[feeTo] = balances[feeTo].add(fee);\n', '        }\n', '        \n', '        balances[sender] = balances[sender].sub(amount);\n', '        balances[recipient] = balances[recipient].add(amount.sub(fee));\n', '        \n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    \n', '    function _approve(address tokenOwner, address spender, uint256 amount) internal {\n', '        allowed[tokenOwner][spender] = amount;\n', '    }\n', '    \n', '}']