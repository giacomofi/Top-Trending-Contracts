['pragma solidity ^0.6.6;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal virtual view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal virtual view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            size := extcodesize(account)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{value: weiValue}(\n', '            data\n', '        );\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    \n', '    bool private _isTransferable = false;\n', '    \n', '    address private _crowdAddress;\n', '    address private _racerAddress;\n', '    address private _poolRewardAddress;\n', '\n', '\n', '    constructor(string memory name, string memory symbol, uint256 amount) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '        _totalSupply = amount * 10 ** uint256(_decimals);\n', '        _balances[owner()] = _totalSupply;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender)\n', '        public\n', '        virtual\n', '        override\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', '            _allowances[sender][_msgSender()].sub(\n', '                amount,\n', '                "ERC20: transfer amount exceeds allowance"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].add(addedValue)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].sub(\n', '                subtractedValue,\n', '                "ERC20: decreased allowance below zero"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '    \n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(_isTransferable || sender == owner());\n', '        require(sender != _poolRewardAddress);\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(\n', '            amount,\n', '            "ERC20: transfer amount exceeds balance"\n', '        );\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(\n', '            amount,\n', '            "ERC20: burn amount exceeds balance"\n', '        );\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '    function _beforeTokenTransfer(\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) internal virtual {}\n', '\n', '    function _setPoolRewardAddress(\n', '        address poolRewardAddress\n', '    ) internal {\n', '        _poolRewardAddress = poolRewardAddress;\n', '    }\n', '\n', '    function _setRacerAddress(\n', '        address contractAddress\n', '    ) internal {\n', '        _racerAddress = contractAddress;\n', '    }\n', '\n', '    function _setCrowdAddress(\n', '        address contractAddress\n', '    ) internal {\n', '        _crowdAddress = contractAddress;\n', '    }\n', '    \n', '    function _purchase(\n', '       address recipient, \n', '       uint256 amount\n', '    ) internal {\n', '        require(msg.sender == _crowdAddress);\n', '        _transfer(owner(), recipient, amount);\n', '    }\n', '    \n', '    function _transferReward(\n', '       address recipient, \n', '       uint256 amount\n', '    ) internal {\n', '        require(msg.sender == _racerAddress);\n', '\n', '        _beforeTokenTransfer(_poolRewardAddress, recipient, amount);\n', '\n', '        _balances[_poolRewardAddress] = _balances[_poolRewardAddress].sub(\n', '            amount,\n', '            "ERC20: transfer amount exceeds balance"\n', '        );\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(_poolRewardAddress, recipient, amount);\n', '    }\n', '    \n', '    function _setTransferable(\n', '        uint8 _value\n', '    ) internal {\n', '        if (_value == 0) {\n', '            _isTransferable = false;\n', '        }\n', '        \n', '        if (_value == 1) {\n', '            _isTransferable = true;\n', '        }\n', '    }\n', '}\n', '\n', 'contract TortoToken is ERC20("Tortoise.Finance", "TRTF", 1000000) {\n', '    \n', '    function transferReward(address recipient, uint256 amount)\n', '    public\n', '    returns (bool)\n', '    {\n', '        _transferReward(recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function setPoolRewardAddress(address poolRewardAddress)\n', '    public\n', '    onlyOwner \n', '    returns (bool)\n', '    {\n', '        _setPoolRewardAddress(poolRewardAddress);\n', '        return true;\n', '    }\n', '    \n', '    function setRacerAddress(address contractAddress)\n', '    public\n', '    onlyOwner \n', '    returns (bool)\n', '    {\n', '        _setRacerAddress(contractAddress);\n', '        return true;\n', '    }\n', '    \n', '    function setCrowdAddress(address contractAddress)\n', '    public\n', '    onlyOwner \n', '    returns (bool)\n', '    {\n', '        _setCrowdAddress(contractAddress);\n', '        return true;\n', '    }\n', '    \n', '    function purchase(address recipient, uint256 amount)\n', '    public\n', '    returns (bool)\n', '    {\n', '        _purchase(recipient, amount);\n', '        return true;\n', '    }\n', '    \n', '    function setTransferable(uint8 _value) public \n', '    onlyOwner \n', '    virtual {\n', '        _setTransferable(_value);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n']
['pragma solidity ^0.6.6;\n', '\n', 'import "./TRTF.sol";\n', '\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '  using Address for address;\n', '\n', '  TortoToken private token;\n', '\n', '  uint256 public cap = 500 ether;\n', '\n', '  address payable private wallet; \n', '\n', '  uint256 public rate = 500;\n', '\n', '  uint256 public minContribution = 0.5 ether;\n', '  uint256 public maxContribution = 5 ether;\n', '\n', '  uint256 public weiRaised;\n', '  mapping (address => uint256) public contributions;\n', '\n', '  bool public isCrowdsaleFinalized = false;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function CrowdsaleStarter(TortoToken _token)  public onlyOwner {\n', '    token = _token;\n', '    wallet = address(uint160(owner()));\n', '  }\n', '\n', '  receive () external payable {\n', '    purchaseTokens(msg.sender);\n', '  }\n', '\n', '  function purchaseTokens(address recipient) public payable {\n', '    require(recipient != address(0));\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '    uint256 amount = getTokenAmount(weiAmount);\n', '\n', '    weiAmount = weiRaised.add(weiAmount);\n', '    contributions[recipient] = contributions[recipient].add(weiAmount);\n', '\n', '    token.purchase(recipient, amount);\n', '    emit TokenPurchase(msg.sender, recipient, weiAmount, amount);\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  function hasEnded() public view returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return capReached || isCrowdsaleFinalized;\n', '  }\n', '\n', '  function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    return tokens;\n', '  }\n', '\n', '  function validPurchase() internal view returns (bool) {\n', '    require(weiRaised.add(msg.value) <= cap);\n', '    bool moreThanMinPurchase = msg.value >= minContribution;\n', '    bool lessThanMaxPurchase = contributions[msg.sender] + msg.value <= maxContribution;\n', '    return  moreThanMinPurchase  && lessThanMaxPurchase && !isCrowdsaleFinalized;\n', '  }\n', '\n', '  function finalizeCrowdsale() public onlyOwner {\n', '    isCrowdsaleFinalized = true;\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n']
