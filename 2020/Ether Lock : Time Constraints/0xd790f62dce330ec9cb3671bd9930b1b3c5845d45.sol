['pragma solidity ^0.7.4;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'contract Context {\n', '    constructor() {}\n', '\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    function totalSupply() override public view returns (uint256) {\n', '        \n', '        \n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account)override public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount)override public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) override\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount)override public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    )override public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', '            _allowances[sender][_msgSender()].sub(\n', '                amount,\n', '                "ERC20: transfer amount exceeds allowance"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].add(addedValue)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].sub(\n', '                subtractedValue,\n', '                "ERC20: decreased allowance below zero"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(\n', '            amount,\n', '            "ERC20: transfer amount exceeds balance"\n', '        );\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(\n', '            amount,\n', '            "ERC20: burn amount exceeds balance"\n', '        );\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(\n', '            account,\n', '            _msgSender(),\n', '            _allowances[account][_msgSender()].sub(\n', '                amount,\n', '                "ERC20: burn amount exceeds allowance"\n', '            )\n', '        );\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.4.22 <0.8.0;\n', '\n', '// "SPDX-License-Identifier: MIT"\n', '\n', 'contract SpringField is ERC20 {\n', '    using SafeMath for uint256;\n', '    IERC20 public token;\n', '    uint256 public initialBlock;\n', '    uint256 public totalBlocks;\n', '    uint8 public decimals = 18;\n', '    address[] stakers;\n', '    string public name;\n', '    string public symbol;\n', '\n', '    struct stakeData {\n', '        address staker;\n', '        uint256 amount;\n', '        uint256 blockNumber;\n', '        uint256 uBlockNumber;\n', '        uint256 rewards;\n', '    }\n', '\n', '    mapping(address => mapping(uint256 => stakeData)) public stakes;\n', '    mapping(address => uint256) public stakeCount;\n', '\n', '    constructor(IERC20 _token) {\n', '        token = _token;\n', '        name = "SpringField";\n', '        symbol = "ySIMP";\n', '        initialBlock = block.number;\n', '        totalBlocks= 2389091;\n', '    }\n', '\n', '    function enter(uint256 _amount) public {\n', '        bool available = false;\n', '        stakes[msg.sender][stakeCount[msg.sender]] = stakeData(\n', '            msg.sender,\n', '            _amount,\n', '            block.number,\n', '            0,\n', '            0\n', '        );\n', '        stakeCount[msg.sender] += 1;\n', '        for(uint i=0;i<stakers.length;i++){\n', '            if(stakers[i]==msg.sender){\n', '                available=true;\n', '                break;\n', '            }else{\n', '                continue;\n', '            }\n', '        }\n', '        if(!available){\n', '            stakers.push(msg.sender);\n', '        }\n', '     \n', '        uint256 usersSushi = token.balanceOf(msg.sender);\n', '        uint256 allowedSushi = token.allowance(msg.sender, address(this));\n', '        require(usersSushi >= _amount, "Insufficient Balance to Stake");\n', '        require(allowedSushi >= _amount, "Allowed balance is Insufficient");\n', '     \n', '        token.transferFrom(msg.sender, address(this), _amount);\n', '    \n', '        _mint(msg.sender, _amount);\n', '    }\n', '\n', '    function getrewards() public {\n', '     \n', '     uint256 rewards =_rewards(msg.sender);\n', '     stakes[msg.sender][0].rewards =  stakes[msg.sender][0].rewards.add(rewards);\n', '        token.transfer(msg.sender, rewards);\n', '    }\n', '\n', '    function unstake() public {\n', '        uint256 stakeAmount = 0;\n', '        for(uint i = 0; i < stakeCount[msg.sender]; i++){\n', '          if(stakes[msg.sender][i].uBlockNumber==0)\n', '          {stakeAmount = stakeAmount.add(stakes[msg.sender][i].amount);}\n', '      }\n', '      uint256 reward = _rewards(msg.sender);\n', '      stakes[msg.sender][0]=stakeData(msg.sender,stakes[msg.sender][0].amount,stakes[msg.sender][0].blockNumber,block.number,stakes[msg.sender][0].rewards.add(reward));\n', '        _burn(msg.sender, stakeAmount);\n', '        token.transfer(msg.sender, reward.add(stakeAmount));\n', '\n', '    }\n', '\n', '\n', '    function _rewards(address adrs) private view returns (uint256) {\n', '        uint256 currentReward = (block.number-initialBlock).mul(11000*10**18).div(totalBlocks);\n', '        uint256 rewardRate;\n', '        uint256 mySum;\n', '        uint256 totalSum;\n', '      for(uint i = 0; i < stakeCount[adrs]; i++){\n', '          if(stakes[adrs][i].uBlockNumber==0)\n', '          {mySum = mySum.add((stakes[adrs][i].amount).mul(block.number-stakes[adrs][i].blockNumber));}\n', '          else{\n', '              currentReward = currentReward.sub(stakes[adrs][i].rewards);\n', '          }\n', '      }\n', '      for(uint i=0;i<stakers.length; i++){\n', '          for(uint j = 0; j< stakeCount[stakers[i]]; j++){\n', '              if(stakes[stakers[i]][i].uBlockNumber==0)\n', '          {totalSum = totalSum.add((stakes[stakers[i]][i].amount).mul(block.number-stakes[stakers[i]][i].blockNumber));}\n', '      }\n', '      }\n', '    rewardRate = mySum.div(totalSum);\n', '        return currentReward.mul(rewardRate)-stakes[adrs][0].rewards;\n', '    }\n', '\n', '    function myReward(address adrs)public view returns (uint256){\n', '        return _rewards(adrs);\n', '    }\n', '\n', '\n', '}']