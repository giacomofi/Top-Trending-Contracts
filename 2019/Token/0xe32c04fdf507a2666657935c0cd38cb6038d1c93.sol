['pragma solidity ^0.5.2;\n', '\n', 'contract ERC20TokenInterface {\n', '\n', '    function totalSupply () external view returns (uint);\n', '    function balanceOf (address tokenOwner) external view returns (uint balance);\n', '    function transfer (address to, uint tokens) external returns (bool success);\n', '    function transferFrom (address from, address to, uint tokens) external returns (bool success);\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    \n', '    function sub (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add (uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Permanent, linearly-distributed vesting with cliff for specified token.\n', ' * Vested accounts can check how many tokens they can withdraw from this smart contract by calling\n', ' * `releasableAmount` function. If they want to withdraw these tokens, they create a transaction\n', ' * to a `release` function, specifying the account to release tokens from as an argument.\n', ' */\n', 'contract CliffTokenVesting {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event Released(address beneficiary, uint256 amount);\n', '\n', '    /**\n', '     * Vesting records.\n', '     */\n', '    struct Beneficiary {\n', '        uint256 start;\n', '        uint256 duration;\n', '        uint256 cliff;\n', '        uint256 totalAmount;\n', '        uint256 releasedAmount;\n', '    }\n', '    mapping (address => Beneficiary) public beneficiary;\n', '\n', '    /**\n', '     * Token address.\n', '     */\n', '    ERC20TokenInterface public token;\n', '\n', '    uint256 public nonce = 310572;\n', '\n', '    /**\n', '     * Whether an account was vested.\n', '     */\n', '    modifier isVestedAccount (address account) { require(beneficiary[account].start != 0); _; }\n', '\n', '    /**\n', '    * Cliff vesting for specific token.\n', '    */\n', '    constructor (ERC20TokenInterface tokenAddress) public {\n', '        require(tokenAddress != ERC20TokenInterface(0x0));\n', '        token = tokenAddress;\n', '    }\n', '\n', '    /**\n', '    * Calculates the releaseable amount of tokens at the current time.\n', '    * @param account Vested account.\n', '    * @return Withdrawable amount in decimals.\n', '    */\n', '    function releasableAmount (address account) public view returns (uint256) {\n', '        return vestedAmount(account).sub(beneficiary[account].releasedAmount);\n', '    }\n', '\n', '    /**\n', '    * Transfers available vested tokens to the beneficiary.\n', '    * @notice The transaction fails if releasable amount = 0, or tokens for `account` are not vested.\n', '    * @param account Beneficiary account.\n', '    */\n', '    function release (address account) public isVestedAccount(account) {\n', '        uint256 unreleased = releasableAmount(account);\n', '        require(unreleased > 0);\n', '        beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.add(unreleased);\n', '        token.transfer(account, unreleased);\n', '        emit Released(account, unreleased);\n', '        if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info\n', '            delete beneficiary[account];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Allows to vest tokens for beneficiary.\n', '     * @notice Tokens for vesting will be withdrawn from `msg.sender`&#39;s account. Sender must first approve this amount\n', '     * for the smart contract.\n', '     * @param account Account to vest tokens for.\n', '     * @param start The absolute date of vesting start in unix seconds.\n', '     * @param duration Duration of vesting in seconds.\n', '     * @param cliff Cliff duration in seconds.\n', '     * @param amount How much tokens in decimals to withdraw.\n', '     */\n', '    function addBeneficiary (\n', '        address account,\n', '        uint256 start,\n', '        uint256 duration,\n', '        uint256 cliff,\n', '        uint256 amount\n', '    ) public {\n', '        require(amount != 0 && start != 0 && account != address(0x0) && cliff < duration && beneficiary[account].start == 0);\n', '        require(token.transferFrom(msg.sender, address(this), amount));\n', '        beneficiary[account] = Beneficiary({\n', '            start: start,\n', '            duration: duration,\n', '            cliff: start.add(cliff),\n', '            totalAmount: amount,\n', '            releasedAmount: 0\n', '        });\n', '    }\n', '\n', '    /**\n', '    * Calculates the amount that is vested.\n', '    * @param account Vested account.\n', '    * @return Amount in decimals.\n', '    */\n', '    function vestedAmount (address account) private view returns (uint256) {\n', '        if (block.timestamp < beneficiary[account].cliff) {\n', '            return 0;\n', '        } else if (block.timestamp >= beneficiary[account].start.add(beneficiary[account].duration)) {\n', '            return beneficiary[account].totalAmount;\n', '        } else {\n', '            return beneficiary[account].totalAmount.mul(\n', '                block.timestamp.sub(beneficiary[account].start)\n', '            ).div(beneficiary[account].duration);\n', '        }\n', '    }\n', '\n', '}']
['pragma solidity ^0.5.2;\n', '\n', 'contract ERC20TokenInterface {\n', '\n', '    function totalSupply () external view returns (uint);\n', '    function balanceOf (address tokenOwner) external view returns (uint balance);\n', '    function transfer (address to, uint tokens) external returns (bool success);\n', '    function transferFrom (address from, address to, uint tokens) external returns (bool success);\n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '    \n', '    function sub (uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add (uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Permanent, linearly-distributed vesting with cliff for specified token.\n', ' * Vested accounts can check how many tokens they can withdraw from this smart contract by calling\n', ' * `releasableAmount` function. If they want to withdraw these tokens, they create a transaction\n', ' * to a `release` function, specifying the account to release tokens from as an argument.\n', ' */\n', 'contract CliffTokenVesting {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    event Released(address beneficiary, uint256 amount);\n', '\n', '    /**\n', '     * Vesting records.\n', '     */\n', '    struct Beneficiary {\n', '        uint256 start;\n', '        uint256 duration;\n', '        uint256 cliff;\n', '        uint256 totalAmount;\n', '        uint256 releasedAmount;\n', '    }\n', '    mapping (address => Beneficiary) public beneficiary;\n', '\n', '    /**\n', '     * Token address.\n', '     */\n', '    ERC20TokenInterface public token;\n', '\n', '    uint256 public nonce = 310572;\n', '\n', '    /**\n', '     * Whether an account was vested.\n', '     */\n', '    modifier isVestedAccount (address account) { require(beneficiary[account].start != 0); _; }\n', '\n', '    /**\n', '    * Cliff vesting for specific token.\n', '    */\n', '    constructor (ERC20TokenInterface tokenAddress) public {\n', '        require(tokenAddress != ERC20TokenInterface(0x0));\n', '        token = tokenAddress;\n', '    }\n', '\n', '    /**\n', '    * Calculates the releaseable amount of tokens at the current time.\n', '    * @param account Vested account.\n', '    * @return Withdrawable amount in decimals.\n', '    */\n', '    function releasableAmount (address account) public view returns (uint256) {\n', '        return vestedAmount(account).sub(beneficiary[account].releasedAmount);\n', '    }\n', '\n', '    /**\n', '    * Transfers available vested tokens to the beneficiary.\n', '    * @notice The transaction fails if releasable amount = 0, or tokens for `account` are not vested.\n', '    * @param account Beneficiary account.\n', '    */\n', '    function release (address account) public isVestedAccount(account) {\n', '        uint256 unreleased = releasableAmount(account);\n', '        require(unreleased > 0);\n', '        beneficiary[account].releasedAmount = beneficiary[account].releasedAmount.add(unreleased);\n', '        token.transfer(account, unreleased);\n', '        emit Released(account, unreleased);\n', '        if (beneficiary[account].releasedAmount == beneficiary[account].totalAmount) { // When done, clean beneficiary info\n', '            delete beneficiary[account];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Allows to vest tokens for beneficiary.\n', "     * @notice Tokens for vesting will be withdrawn from `msg.sender`'s account. Sender must first approve this amount\n", '     * for the smart contract.\n', '     * @param account Account to vest tokens for.\n', '     * @param start The absolute date of vesting start in unix seconds.\n', '     * @param duration Duration of vesting in seconds.\n', '     * @param cliff Cliff duration in seconds.\n', '     * @param amount How much tokens in decimals to withdraw.\n', '     */\n', '    function addBeneficiary (\n', '        address account,\n', '        uint256 start,\n', '        uint256 duration,\n', '        uint256 cliff,\n', '        uint256 amount\n', '    ) public {\n', '        require(amount != 0 && start != 0 && account != address(0x0) && cliff < duration && beneficiary[account].start == 0);\n', '        require(token.transferFrom(msg.sender, address(this), amount));\n', '        beneficiary[account] = Beneficiary({\n', '            start: start,\n', '            duration: duration,\n', '            cliff: start.add(cliff),\n', '            totalAmount: amount,\n', '            releasedAmount: 0\n', '        });\n', '    }\n', '\n', '    /**\n', '    * Calculates the amount that is vested.\n', '    * @param account Vested account.\n', '    * @return Amount in decimals.\n', '    */\n', '    function vestedAmount (address account) private view returns (uint256) {\n', '        if (block.timestamp < beneficiary[account].cliff) {\n', '            return 0;\n', '        } else if (block.timestamp >= beneficiary[account].start.add(beneficiary[account].duration)) {\n', '            return beneficiary[account].totalAmount;\n', '        } else {\n', '            return beneficiary[account].totalAmount.mul(\n', '                block.timestamp.sub(beneficiary[account].start)\n', '            ).div(beneficiary[account].duration);\n', '        }\n', '    }\n', '\n', '}']
