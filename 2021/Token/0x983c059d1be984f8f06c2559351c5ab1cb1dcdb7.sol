['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-19\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'interface ITITANVault {\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function addTaxFee(uint256 amount) external returns (bool);\n', '}\n', '\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    constructor() {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * TITAN contract\n', ' *\n', ' * Name        : TITAN TOKEN\n', ' * Symbol      : TITAN\n', ' * Total supply: 1,300,000\n', ' * Decimals    : 18\n', ' *\n', ' * ERC20 Token, with the Burnable, Pausable and Ownable from OpenZeppelin\n', ' */\n', 'contract TITANToken is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    uint16 public _taxFee;\n', '    address public _vault;\n', '    address private _tokenOwner;\n', '\n', '    uint8 private _initialMaxTransfers;\n', '    uint256 private _initialMaxTransferAmount;\n', '\n', '    modifier onlyVault() {\n', '        require(_vault == _msgSender(), "Ownable: caller is not vault");\n', '        _;\n', '    }\n', '\n', '    event ChangedTaxFee(address indexed owner, uint16 fee);\n', '    event ChangedVault(\n', '        address indexed owner,\n', '        address indexed oldAddress,\n', '        address indexed newAddress\n', '    );\n', '    event ChangedInitialMaxTransfers(address indexed owner, uint8 count);\n', '\n', '    constructor(address tokenOwner) {\n', '        _name = "Titan Token";\n', '        _symbol = "TITAN";\n', '        _decimals = 18;\n', '\n', '        _tokenOwner = tokenOwner;\n', '\n', '        // set initial tax fee(transfer) fee as 2%\n', '        // It is allow 2 digits under point\n', '        _taxFee = 200;\n', '        _initialMaxTransfers = 50;\n', '        _initialMaxTransferAmount = 1000e18; // initial around  0.1 eth(1000 TITAN)\n', '\n', '        _mint(_tokenOwner, 1300e21);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        if (_checkWithoutFee()) {\n', '            _transfer(_msgSender(), recipient, amount);\n', '        } else {\n', '            uint256 taxAmount = amount.mul(uint256(_taxFee)).div(10000);\n', '            uint256 leftAmount = amount.sub(taxAmount);\n', '            _transfer(_msgSender(), _vault, taxAmount);\n', '            _transfer(_msgSender(), recipient, leftAmount);\n', '\n', '            ITITANVault(_vault).addTaxFee(taxAmount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        if (_checkWithoutFee()) {\n', '            _transfer(sender, recipient, amount);\n', '        } else {\n', '            uint256 feeAmount = amount.mul(uint256(_taxFee)).div(10000);\n', '            uint256 leftAmount = amount.sub(feeAmount);\n', '\n', '            _transfer(sender, _vault, feeAmount);\n', '            _transfer(sender, recipient, leftAmount);\n', '            ITITANVault(_vault).addTaxFee(feeAmount);\n', '        }\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', '            _allowances[sender][_msgSender()].sub(\n', '                amount,\n', '                "ERC20: transfer amount exceeds allowance"\n', '            )\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].add(addedValue)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].sub(\n', '                subtractedValue,\n', '                "ERC20: decreased allowance below zero"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function setTaxFee(uint16 fee) external onlyOwner {\n', '        _taxFee = fee;\n', '        emit ChangedTaxFee(_msgSender(), fee);\n', '    }\n', '\n', '    function setVault(address vault) external onlyOwner {\n', '        require(vault != address(0), "Invalid vault contract address");\n', '        address oldAddress = _vault;\n', '        _vault = vault;\n', '        emit ChangedVault(_msgSender(), oldAddress, _vault);\n', '    }\n', '\n', '    function setInitialMaxTransfers(uint8 count) external onlyOwner {\n', '        _initialMaxTransfers = count;\n', '        emit ChangedInitialMaxTransfers(_msgSender(), count);\n', '    }\n', '\n', '    function burnFromVault(uint256 amount) external onlyVault returns (bool) {\n', '        _burn(_vault, amount);\n', '        return true;\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(\n', '            amount,\n', '            "ERC20: burn amount exceeds balance"\n', '        );\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        if (recipient != _vault) {\n', '            // for anti-bot\n', '            if (sender != _vault && sender != _tokenOwner) {\n', '                if (_initialMaxTransfers != 0) {\n', '                    require(\n', '                        amount <= _initialMaxTransferAmount,\n', '                        "Can\'t transfer more than 1000 TITAN for initial 50 times."\n', '                    );\n', '                    _initialMaxTransfers--;\n', '                }\n', '            }\n', '        }\n', '\n', '        _balances[sender] = _balances[sender].sub(\n', '            amount,\n', '            "ERC20: transfer amount exceeds balance"\n', '        );\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _checkWithoutFee() internal view returns (bool) {\n', '        if (_msgSender() == _vault || _msgSender() == _tokenOwner) {\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}']