['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract YFFSmicrostaking{\n', '\n', '    using SafeMath for uint;\n', '    ERC20 public token;\n', '\n', '    struct Contribution{\n', '        uint amount;\n', '        uint time;\n', '    }\n', '\n', '    struct User{\n', '        address user;\n', '        uint amountAvailableToWithdraw;\n', '        bool exists;\n', '        uint totalAmount;\n', '        uint totalBonusReceived;\n', '        uint withdrawCount;\n', '        Contribution[] contributions;       \n', '    }\n', '\n', '    mapping(address => User) public users;\n', '    \n', '    address[] usersList;\n', '    address owner;\n', '\n', '    uint public totalTokensDeposited;\n', '\n', '    uint public indexOfPayee;\n', '    uint public EthBonus;\n', '    uint public stakeContractBalance;\n', '    uint public bonusRate;\n', '\n', '    uint public indexOfEthSent;\n', '\n', '    bool public depositStatus;\n', '\n', '\n', '\n', '    modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    constructor(address _token, uint _bonusRate) public {\n', '        token = ERC20(_token);\n', '        owner = msg.sender;\n', '        bonusRate = _bonusRate;\n', '    }\n', '\n', '    event OwnerChanged(address newOwner);\n', '\n', '    function ChangeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != 0x0);\n', '        require(_newOwner != owner);\n', '        owner = _newOwner;\n', '\n', '        emit OwnerChanged(_newOwner);\n', '    }\n', '\n', '    event BonusChanged(uint newBonus);\n', '\n', '    function ChangeBonus(uint _newBonus) public onlyOwner {\n', '        require(_newBonus > 0);\n', '        bonusRate = _newBonus;\n', '\n', '        emit BonusChanged(_newBonus);\n', '    }\n', '\n', '    event Deposited(address from, uint amount);\n', '\n', '    function Deposit(uint _value) public returns(bool) {\n', '        require(depositStatus);\n', '        require(_value >= 5 * (10 ** 18));\n', '        require(token.allowance(msg.sender, address(this)) >= _value);\n', '\n', '        User storage user = users[msg.sender];\n', '\n', '        if(!user.exists){\n', '            usersList.push(msg.sender);\n', '            user.user = msg.sender;\n', '            user.exists = true;\n', '        }\n', '        user.totalAmount = user.totalAmount.add(_value);\n', '        totalTokensDeposited = totalTokensDeposited.add(_value);\n', '        user.contributions.push(Contribution(_value, now));\n', '        token.transferFrom(msg.sender, address(this), _value);\n', '\n', '        stakeContractBalance = token.balanceOf(address(this));\n', '\n', '        emit Deposited(msg.sender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    function ChangeDepositeStatus(bool _status) public onlyOwner{\n', '        depositStatus = _status;\n', '    }\n', '\n', '    function MicroStakeMultiSendToken() public onlyOwner {\n', '        uint i = indexOfPayee;\n', '        \n', '        while(i<usersList.length && msg.gas > 90000){\n', '            User storage currentUser = users[usersList[i]];\n', '            \n', '            uint amount = 0;\n', '            for(uint q = 0; q < currentUser.contributions.length; q++){\n', '                if(now > currentUser.contributions[q].time + 1 hours && now < currentUser.contributions[q].time + 90 days){\n', '                    amount = amount.add(currentUser.contributions[q].amount);\n', '                }\n', '            }\n', '            \n', '            if(amount >= 5 * (10 ** 18) && amount < 100 * (10 ** 18)){  //TODO\n', '                uint bonus = amount.mul(bonusRate).div(10000);\n', '\n', '                require(token.balanceOf(address(this)) >= bonus);\n', '                currentUser.totalBonusReceived = currentUser.totalBonusReceived.add(bonus);\n', '               \n', '                require(token.transfer(currentUser.user, bonus));\n', '            }\n', '            i++;\n', '        }\n', '\n', '        indexOfPayee = i;\n', '        if( i == usersList.length){\n', '            indexOfPayee = 0;\n', '        }\n', '        stakeContractBalance = token.balanceOf(address(this));\n', '    }\n', '\n', '\n', '    event EthBonusSet(uint bonus);\n', '    function SetEthBonus(uint _EthBonus) public onlyOwner {\n', '        require(_EthBonus > 0);\n', '        EthBonus = _EthBonus;\n', '        stakeContractBalance = token.balanceOf(address(this));\n', '        indexOfEthSent = 0;\n', '\n', '        emit EthBonusSet(_EthBonus);\n', '    } \n', '\n', '    function MicroStakeMultiSendEth() public onlyOwner {\n', '        require(EthBonus > 0);\n', '        require(stakeContractBalance > 0);\n', '        uint p = indexOfEthSent;\n', '\n', '        while(p<usersList.length && msg.gas > 90000){\n', '            User memory currentUser = users[usersList[p]];\n', '            \n', '            uint amount = 0;\n', '            for(uint q = 0; q < currentUser.contributions.length; q++){\n', '                if(now > currentUser.contributions[q].time + 90 days){\n', '                    amount = amount.add(currentUser.contributions[q].amount);\n', '                }\n', '            }            \n', '            if(amount >= 5 * (10 ** 18) && amount < 100 * (10 ** 18)){  //TODO\n', '                uint EthToSend = EthBonus.mul(amount).div(totalTokensDeposited);\n', '                \n', '                require(address(this).balance >= EthToSend);\n', '                currentUser.user.transfer(EthToSend);\n', '            }\n', '            p++;\n', '        }\n', '\n', '        indexOfEthSent = p;\n', '\n', '    }\n', '\n', '\n', '    event MultiSendComplete(bool status);\n', '    function MultiSendTokenComplete() public onlyOwner {\n', '        indexOfPayee = 0;\n', '        emit MultiSendComplete(true);\n', '    }\n', '\n', '    event Withdrawn(address withdrawnTo, uint amount);\n', '    function WithdrawTokens(uint _value) public {\n', '        require(_value > 0);\n', '\n', '        User storage user = users[msg.sender];\n', '\n', '        for(uint q = 0; q < user.contributions.length; q++){\n', '            if(now > user.contributions[q].time + 1 weeks){\n', '                user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.add(user.contributions[q].amount);\n', '            }\n', '        }\n', '\n', '        require(_value <= user.amountAvailableToWithdraw);\n', '        require(token.balanceOf(address(this)) >= _value);\n', '\n', '        user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.sub(_value);\n', '        user.totalAmount = user.totalAmount.sub(_value);\n', '\n', '        user.withdrawCount = user.withdrawCount.add(1);\n', '\n', '        totalTokensDeposited = totalTokensDeposited.sub(_value);\n', '        token.transfer(msg.sender, _value);\n', '\n', '        stakeContractBalance = token.balanceOf(address(this));\n', '        emit Withdrawn(msg.sender, _value);\n', '\n', '\n', '    }\n', '\n', '\n', '    function() public payable{\n', '\n', '    }\n', '\n', '    function WithdrawETH(uint amount) public onlyOwner{\n', '        require(amount > 0);\n', '        require(address(this).balance >= amount * 1 ether);\n', '\n', '        msg.sender.transfer(amount * 1 ether);\n', '    }\n', '\n', '    function CheckAllowance() public view returns(uint){\n', '        uint allowance = token.allowance(msg.sender, address(this));\n', '        return allowance;\n', '    }\n', '\n', '    function GetBonusReceived() public view returns(uint){\n', '        User memory user = users[msg.sender];\n', '        return user.totalBonusReceived;\n', '    }\n', '    \n', '    function GetContributionsCount() public view returns(uint){\n', '        User memory user = users[msg.sender];\n', '        return user.contributions.length;\n', '    }\n', '\n', '    function GetWithdrawCount() public view returns(uint){\n', '        User memory user = users[msg.sender];\n', '        return user.withdrawCount;\n', '    }\n', '\n', '    function GetLockedTokens() public view returns(uint){\n', '        User memory user = users[msg.sender];\n', '\n', '        uint i;\n', '        uint lockedTokens = 0;\n', '        for(i = 0; i < user.contributions.length; i++){\n', '            if(now < user.contributions[i].time + 24 hours){\n', '                lockedTokens = lockedTokens.add(user.contributions[i].amount);\n', '            }\n', '        }\n', '\n', '        return lockedTokens;\n', '\n', '    }\n', '\n', '    function ReturnTokens(address destination, address account, uint amount) public onlyOwner{\n', '        ERC20(destination).transfer(account,amount);\n', '    }\n', '   \n', '}']