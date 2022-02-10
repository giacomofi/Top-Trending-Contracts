['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.8;\n', '\n', 'interface Staking {\n', '    function deposit(address account, uint256 amount) external returns (bool);\n', '\n', '    function withdraw(address account) external returns (bool);\n', '\n', '    function stake(uint256 reward) external returns (bool);\n', '\n', '    event Reward(uint256 reward);\n', '    event Debug(uint256 value, string message);\n', '}\n', '\n', 'interface ERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'abstract contract Ownable {\n', '    address private _owner;\n', '    address private _admin;\n', '\n', '    constructor () public {\n', '        _owner = msg.sender;\n', '        _admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender || _admin == msg.sender, "Ownable: caller is not the owner or admin");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'abstract contract Deprecateble is Ownable {\n', '    bool internal deprecated;\n', '\n', '    modifier onlyNotDeprecated() {\n', '        require(!deprecated, "Deprecateble: contract is deprecated");\n', '        _;\n', '    }\n', '\n', '    function deprecate() external onlyOwner {\n', '        deprecated = true;\n', '        emit Deprecate(msg.sender);\n', '    }\n', '\n', '    event Deprecate(address indexed account);\n', '}\n', '\n', 'abstract contract StandartToken is Staking, ERC20, Ownable, Deprecateble {\n', '    uint256[] private percents;\n', '    uint256 private _liquidTotalSupply;\n', '    uint256 private _liquidDeposit;\n', '    uint256 constant private PERCENT_FACTOR = 10 ** 12;\n', '\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => uint256) private _deposits;\n', '    mapping(address => uint256) private _rewardIndexForAccount;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    constructor () public {\n', '        percents.push(PERCENT_FACTOR);\n', '    }\n', '\n', '    function deposit(address account, uint256 amount) external onlyOwner onlyNotDeprecated override virtual returns (bool)  {\n', '        require(amount > 0, "amount should be > 0");\n', '        require(account != address(0), "deposit to the zero address");\n', '\n', '        uint256 liquidDeposit = _liquidDeposit;\n', '        require(liquidDeposit + amount >= liquidDeposit, "addition overflow for deposit");\n', '        _liquidDeposit = liquidDeposit + amount;\n', '\n', '        uint256 oldDeposit = _deposits[account];\n', '        uint256 rewardIndex = _rewardIndexForAccount[account];\n', '        if (oldDeposit == 0) {\n', '            uint256 balance = balanceOf(account);\n', '            _balances[account] = balance;\n', '            _deposits[account] = amount;\n', '            _rewardIndexForAccount[account] = percents.length - 1;\n', '        } else {\n', '            if (rewardIndex == percents.length - 1) {\n', '                require(oldDeposit + amount >= oldDeposit, "addition overflow for deposit");\n', '                _deposits[account] = oldDeposit + amount;\n', '            } else {\n', '                uint256 balance = balanceOf(account);\n', '                _balances[account] = balance;\n', '                _deposits[account] = amount;\n', '                _rewardIndexForAccount[account] = percents.length - 1;\n', '            }\n', '        }\n', '\n', '        emit Transfer(address(0), account, amount);\n', '        return true;\n', '    }\n', '\n', '    function stake(uint256 reward) external onlyOwner onlyNotDeprecated override virtual returns (bool) {\n', '        require(reward > 0, "reward should be > 0");\n', '\n', '        uint256 liquidTotalSupply = _liquidTotalSupply;\n', '        uint256 liquidDeposit = _liquidDeposit;\n', '\n', '        if (liquidTotalSupply == 0) {\n', '            percents.push(PERCENT_FACTOR);\n', '        } else {\n', '            uint256 oldPercent = percents[percents.length - 1];\n', '            uint256 percent = reward * PERCENT_FACTOR;\n', '\n', '            emit Debug(liquidTotalSupply, "reward totalSupply");\n', '\n', '            require(percent / PERCENT_FACTOR == reward, "multiplication overflow for percent init");\n', '            percent /= liquidTotalSupply;\n', '            require(percent + PERCENT_FACTOR >= percent, "addition overflow for percent");\n', '            uint256 newPercent = percent + PERCENT_FACTOR;\n', '\n', '            require(newPercent * oldPercent / oldPercent == newPercent, "multiplication overflow for percent");\n', '            percents.push(newPercent * oldPercent / PERCENT_FACTOR);\n', '            emit Debug(newPercent * oldPercent / PERCENT_FACTOR, "reward new percent");\n', '\n', '            require(liquidTotalSupply + reward >= liquidTotalSupply, "addition overflow for total supply + reward");\n', '            liquidTotalSupply = liquidTotalSupply + reward;\n', '        }\n', '\n', '        require(liquidTotalSupply + liquidDeposit >= liquidTotalSupply, "addition overflow for total supply");\n', '        _liquidTotalSupply = liquidTotalSupply + liquidDeposit;\n', '        _liquidDeposit = 0;\n', '\n', '        emit Reward(reward);\n', '        return true;\n', '    }\n', '\n', '    function withdraw(address account) external onlyOwner onlyNotDeprecated override virtual returns (bool) {\n', '        uint256 oldDeposit = _deposits[account];\n', '        uint256 rewardIndex = _rewardIndexForAccount[account];\n', '\n', '        if (rewardIndex == percents.length - 1) {\n', '            uint256 balance = _balances[account];\n', '            require(balance <= _liquidTotalSupply, "subtraction overflow for total supply");\n', '            _liquidTotalSupply = _liquidTotalSupply - balance;\n', '\n', '            require(oldDeposit <= _liquidDeposit, "subtraction overflow for liquid deposit");\n', '            _liquidDeposit = _liquidDeposit - oldDeposit;\n', '\n', '            require(balance + oldDeposit >= balance, "addition overflow for total balance + oldDeposit");\n', '            emit Transfer(account, address(0), balance + oldDeposit);\n', '        } else {\n', '            uint256 balance = balanceOf(account);\n', '            uint256 liquidTotalSupply = _liquidTotalSupply;\n', '            require(balance <= liquidTotalSupply, "subtraction overflow for total supply");\n', '            _liquidTotalSupply = liquidTotalSupply - balance;\n', '            emit Transfer(account, address(0), balance);\n', '        }\n', '\n', '        _balances[account] = 0;\n', '        _deposits[account] = 0;\n', '        return true;\n', '    }\n', '\n', '    // ERC20\n', '    function totalSupply() external view override virtual returns (uint256) {\n', '        uint256 liquidTotalSupply = _liquidTotalSupply;\n', '        uint256 liquidDeposit = _liquidDeposit;\n', '\n', '        require(liquidTotalSupply + liquidDeposit >= liquidTotalSupply, "addition overflow for total supply");\n', '        return liquidTotalSupply + liquidDeposit;\n', '    }\n', '\n', '    function balanceOf(address account) public view override virtual returns (uint256) {\n', '        uint256 balance = _balances[account];\n', '        uint256 oldDeposit = _deposits[account];\n', '\n', '        if (balance == 0 && oldDeposit == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 rewardIndex = _rewardIndexForAccount[account];\n', '        if (rewardIndex == percents.length - 1) {\n', '            require(balance + oldDeposit >= balance, "addition overflow for balance");\n', '            return balance + oldDeposit;\n', '        }\n', '\n', '        if (oldDeposit == 0) {\n', '            uint256 profit = percents[percents.length - 1];\n', '            return profit * balance / percents[rewardIndex];\n', '        } else {\n', '            uint256 profit = percents[rewardIndex + 1];\n', '            balance = profit * balance / percents[rewardIndex];\n', '            require(balance + oldDeposit >= balance, "addition overflow for balance");\n', '            balance = balance + oldDeposit;\n', '\n', '            uint256 newProfit = percents[percents.length - 1];\n', '            return newProfit * balance / percents[rewardIndex + 1];\n', '        }\n', '    }\n', '\n', '    function allowance(address owner, address spender) external view override virtual returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal onlyNotDeprecated virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) external override virtual returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) external override virtual returns (bool) {\n', '        uint256 temp = _allowances[msg.sender][spender];\n', '        require(temp + addedValue >= temp, "addition overflow");\n', '        _approve(msg.sender, spender, temp + addedValue);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) external override virtual returns (bool) {\n', '        uint256 temp = _allowances[msg.sender][spender];\n', '        require(subtractedValue <= temp, "ERC20: decreased allowance below zero");\n', '        _approve(msg.sender, spender, temp - subtractedValue);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) external override virtual returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external override virtual returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 temp = _allowances[sender][msg.sender];\n', '        require(amount <= temp, "ERC20: transfer amount exceeds allowance");\n', '        _approve(sender, msg.sender, temp - amount);\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal onlyNotDeprecated virtual {\n', '        require(amount > 0, "amount should be > 0");\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        uint256 oldDeposit = _deposits[sender];\n', '        uint256 rewardIndex = _rewardIndexForAccount[sender];\n', '        uint256 depositDiff;\n', '        if (oldDeposit == 0 || rewardIndex != percents.length - 1) {\n', '            uint256 senderBalance = balanceOf(sender);\n', '            require(amount <= senderBalance, "ERC20: transfer amount exceeds balance");\n', '            _balances[sender] = senderBalance - amount;\n', '            _deposits[sender] = 0;\n', '            _rewardIndexForAccount[sender] = percents.length - 1;\n', '        } else {\n', '            if (amount <= oldDeposit) {\n', '                _deposits[sender] = oldDeposit - amount;\n', '                depositDiff = amount;\n', '            } else {\n', '                uint256 senderBalance = _balances[sender];\n', '                require(amount - oldDeposit <= senderBalance, "ERC20: transfer amount exceeds balance");\n', '                _balances[sender] = senderBalance - (amount - oldDeposit);\n', '                _deposits[sender] = 0;\n', '                depositDiff = oldDeposit;\n', '            }\n', '        }\n', '\n', '        oldDeposit = _deposits[recipient];\n', '        rewardIndex = _rewardIndexForAccount[recipient];\n', '        if (oldDeposit == 0 || rewardIndex != percents.length - 1) {\n', '            uint256 recipientBalance = balanceOf(recipient);\n', '            require((amount - depositDiff) + recipientBalance >= recipientBalance, "ERC20: addition overflow for recipient balance");\n', '            _balances[recipient] = recipientBalance + (amount - depositDiff);\n', '            _rewardIndexForAccount[recipient] = percents.length - 1;\n', '            _deposits[recipient] = depositDiff;\n', '        } else {\n', '            uint256 recipientBalance = _balances[recipient];\n', '            _balances[recipient] = recipientBalance + (amount - depositDiff);\n', '            _deposits[recipient] = oldDeposit + depositDiff;\n', '        }\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '}\n', '\n', 'contract USDN is StandartToken {\n', '    function name() external pure returns (string memory) {\n', '        return "Neutrino USD";\n', '    }\n', '\n', '    function symbol() external pure returns (string memory) {\n', '        return "USDN";\n', '    }\n', '\n', '    function decimals() external pure returns (uint8) {\n', '        return 18;\n', '    }\n', '}']