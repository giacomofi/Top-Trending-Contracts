['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-10\n', '*/\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see `ERC20Detailed`.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from the caller&#39;s account to `recipient`.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the caller&#39;s tokens.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * > Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', '     * condition is to first reduce the spender&#39;s allowance to 0 and set the\n', '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an `Approval` event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', '     * allowance mechanism. `amount` is then deducted from the caller&#39;s\n', '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/Fundraiser.sol\n', '\n', 'pragma solidity ^0.5.1;\n', '\n', '\n', 'contract Fundable {\n', '    \n', '    function() external payable {\n', '        require(msg.data.length == 0); // only allow plain transfers\n', '    }\n', '    \n', '    function tokenBalance(address token) public view returns (uint) {\n', '        if (token == address(0x0)) {\n', '            return address(this).balance;\n', '        } else {\n', '            return IERC20(token).balanceOf(address(this));\n', '        }\n', '    }\n', '   \n', '    function send(address payable to, address token, uint amount) internal {\n', '        if (token == address(0x0)) {\n', '            to.transfer(amount);\n', '        } else {\n', '            IERC20(token).transfer(to, amount);\n', '        }\n', '    }\n', '}\n', '\n', 'contract Fundraiser is Fundable {\n', '    address payable public recipient;\n', '    uint public expiration;\n', '    Grant public grant;\n', '    mapping (address => uint) disbursed;\n', '\n', '    constructor(address payable _recipient, address payable _sponsor, uint _expiration) public {\n', '        require(_expiration > now);\n', '        require(_expiration < now + 365 days);\n', '        recipient = _recipient;\n', '        expiration = _expiration;\n', '        grant = new Grant(this, _sponsor);\n', '    }\n', '\n', '    function hasExpired() public view returns (bool) {\n', '        return now >= expiration;\n', '    }\n', '    \n', '    function raised(address token) external view returns (uint) {\n', '        return tokenBalance(token) + disbursed[token] + grant.tokenBalance(token) - grant.refundable(token);\n', '    }\n', '\n', '    function disburse(address token) external {\n', '        grant.tally(token);\n', '        uint amount = tokenBalance(token);\n', '        disbursed[token] += amount;\n', '        send(recipient, token, amount);\n', '    }\n', '\n', '}\n', '\n', 'contract Grant is Fundable {\n', '    struct Tally {\n', '        uint sponsored;\n', '        uint matched;\n', '    }\n', '\n', '    Fundraiser public fundraiser;\n', '    address payable public sponsor; \n', '    mapping (address => Tally) tallied;\n', '    \n', '    constructor(Fundraiser _fundraiser, address payable _sponsor) public {\n', '        fundraiser = _fundraiser;\n', '        sponsor = _sponsor;\n', '    }\n', '    \n', '    function refund(address token) external {\n', '        tally(token);\n', '        send(sponsor, token, tokenBalance(token));\n', '    }\n', '\n', '    function refundable(address token) external view returns (uint) {\n', '        uint balance = tokenBalance(token);\n', '        Tally storage t = tallied[token];\n', '        return isTallied(t) ? balance : balance - matchable(token);\n', '    }\n', '    \n', '    function sponsored(address token) external view returns (uint) {\n', '        Tally storage t = tallied[token];\n', '        return isTallied(t) ? t.sponsored : tokenBalance(token);\n', '    }\n', '\n', '    function matched(address token) external view returns (uint) {\n', '        Tally storage t = tallied[token];\n', '        return isTallied(t) ? t.matched : matchable(token);\n', '    }\n', '    \n', '    function tally(address token) public {\n', '        require(fundraiser.hasExpired());\n', '        Tally storage t = tallied[token];\n', '        if (!isTallied(t)) {\n', '            t.sponsored = tokenBalance(token);\n', '            t.matched = matchable(token);\n', '            send(address(fundraiser), token, t.matched);\n', '        }\n', '    }\n', '    \n', '    // only valid before tally\n', '    function matchable(address token) private view returns (uint) {\n', '        uint donations = fundraiser.tokenBalance(token);\n', '        uint granted = tokenBalance(token);\n', '        return donations > granted ? granted : donations;\n', '    }\n', '\n', '    function isTallied(Tally storage t) private view returns (bool) {\n', '        return t.sponsored != 0;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/FundraiserFactory.sol\n', '\n', 'pragma solidity ^0.5.1;\n', '\n', '\n', 'contract FundraiserFactory {\n', '\n', '\tevent NewFundraiser(\n', '\t\taddress indexed deployer,\n', '\t\taddress indexed recipient,\n', '\t\taddress indexed sponsor,\n', '\t\tFundraiser fundraiser,\n', '\t\tGrant grant,\n', '\t\tuint expiration);\n', '    \n', '    function newFundraiser(address payable _recipient, address payable _sponsor, uint _expiration) public returns (Fundraiser fundraiser, Grant grant) {\n', '        fundraiser = new Fundraiser(_recipient, _sponsor, _expiration);\n', '        grant = fundraiser.grant();\n', '        emit NewFundraiser(msg.sender, _recipient, _sponsor, fundraiser, grant, _expiration);\n', '    }\n', '\n', '}']