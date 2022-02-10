['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', "import './IERC20.sol';\n", "import './IERC20Metadata.sol';\n", "import './Ownable.sol';\n", "import './TokenTimelock.sol';\n", '\n', 'contract ERC20 is IERC20, IERC20Metadata {\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '\n', '    constructor (string memory name_, string memory symbol_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '    }\n', '    \n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        uint256 currentAllowance = _allowances[sender][msg.sender];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        _approve(sender, msg.sender, currentAllowance - amount);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[msg.sender][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        _approve(msg.sender, spender, currentAllowance - subtractedValue);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[sender] = senderBalance - amount;\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply += amount;\n', '        _balances[account] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        uint256 accountBalance = _balances[account];\n', '        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '        _balances[account] = accountBalance - amount;\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', 'contract AIOZToken is ERC20, Ownable {\n', '    uint256 private _maxTotalSupply;\n', '    \n', '    constructor() ERC20("AIOZ Network", "AIOZ") {\n', '        _maxTotalSupply = 1000000000e18;\n', '        \n', '        // init timelock factory\n', '        TimelockFactory timelockFactory = new TimelockFactory();\n', '\n', '        // ERC20\n', '        // public sales\n', '        mint(0x076592ad72b79bBaBDD05aDd7d367f44f2CFf658, 10333333e18); // for Paid Ignition\n', '        // private sales\n', '        mint(0xF8477220f8375968E38a3B79ECA4343822b53af2, 73000000e18*25/100);\n', '        address privateSalesLock = timelockFactory.createTimelock(this, 0xF8477220f8375968E38a3B79ECA4343822b53af2, block.timestamp + 30 days, 73000000e18*25/100, 30 days);\n', '        mint(privateSalesLock, 73000000e18*75/100);\n', '        // team\n', '        address teamLock = timelockFactory.createTimelock(this, 0x82E83054CC631C0Da85Ca67087E45ca31b93F29b, block.timestamp + 180 days, 250000000e18*8/100, 30 days);\n', '        mint(teamLock, 250000000e18);\n', '        // advisors\n', '        address advisorsLock = timelockFactory.createTimelock(this, 0xBbf78c2Ee1794229e31af81c83F4d5125F08FE0F, block.timestamp + 90 days, 50000000e18*8/100, 30 days);\n', '        mint(advisorsLock, 50000000e18);\n', '        // marketing\n', '        mint(0x9E2F8e278585CAfD3308E894d2E09ffEc520b1E9, 30000000e18*10/100);\n', '        address marketingERC20Lock = timelockFactory.createTimelock(this, 0x9E2F8e278585CAfD3308E894d2E09ffEc520b1E9, block.timestamp + 30 days, 30000000e18*5/100, 30 days);\n', '        mint(marketingERC20Lock, 30000000e18*90/100);\n', '        // exchange liquidity provision\n', '        mint(0x6c3D8872002B66C808aE462Db314B87962DCC7aF, 23333333e18);\n', '        // ecosystem growth\n', '        address growthLock = timelockFactory.createTimelock(this, 0xCFd6736a11e76c0e3418FEEbb788822211d92F1e, block.timestamp + 90 days, 0, 0);\n', '        mint(growthLock, 530000000e18);\n', '\n', '        // BEP20\n', '        // // public sales\n', '        // mint(0xc9Fc843DBAA8ccCcf37E09b67DeEa5f963E3919E, 6666667e18); // for BSCPad\n', '        // // marketing\n', '        // mint(0x7e318e80EB8e401451334cAa2278E39Da7F6C49B, 20000000e18*10/100);\n', '        // address marketingBEP20Lock = timelockFactory.createTimelock(this, 0x7e318e80EB8e401451334cAa2278E39Da7F6C49B, block.timestamp + 30 days, 20000000e18*5/100, 30 days);\n', '        // mint(marketingBEP20Lock, 20000000e18*90/100);\n', '        // // exchange liquidity provision\n', '        // mint(0x0a515Ac284E3c741575A4fd71C27e377a19D5E6D, 6666667e18);\n', '    }\n', '\n', '    function mint(address account, uint256 amount) public onlyOwner returns (bool) {\n', '        require(totalSupply() + amount <= _maxTotalSupply, "AIOZ Token: mint more than the max total supply");\n', '        _mint(account, amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 amount) public onlyOwner returns (bool) {\n', '        _burn(msg.sender, amount);\n', '        return true;\n', '    }\n', '}']