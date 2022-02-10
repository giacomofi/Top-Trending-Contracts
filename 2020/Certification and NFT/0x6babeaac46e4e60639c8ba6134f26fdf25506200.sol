['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title PaymentSplitter\n', ' * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware\n', ' * that the Ether will be split in this way, since it is handled transparently by the contract.\n', ' *\n', ' * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each\n', ' * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim\n', ' * an amount proportional to the percentage of total shares they were assigned.\n', ' *\n', ' * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the\n', ' * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}\n', ' * function.\n', ' */\n', 'contract PaymentSplitter is Context {\n', '    using SafeMath for uint256;\n', '\n', '    event PayeeAdded(address account, uint256 shares);\n', '    event PaymentReleased(address to, uint256 amount);\n', '    event PaymentReceived(address from, uint256 amount, uint256 blockNumber);\n', '\n', '    uint256 private _totalShares;\n', '    uint256 private _totalReleased;\n', '    uint256 private _totalReceived; // how much eth has been received in total?\n', '\n', '    mapping(address => uint256) private _shares;\n', '    mapping(address => uint256) private _released;\n', '    address[] private _payees;\n', '\n', '    /**\n', '     * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at\n', '     * the matching position in the `shares` array.\n', '     *\n', '     * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no\n', '     * duplicates in `payees`.\n', '     */\n', '    constructor () public {\n', '\n', '      // calculate total shares so we know what the fuck is going on before deployment\n', '        _addPayee(0xe4DF1e8DD0E7c02553815C5b715bA7540679FFEf, 16000);\n', '        _addPayee(0x7943d603924b37ee2BA8848Af7dC4985729244E8, 17000);\n', '        _addPayee(0x86b2881fA900DF585b256D3004bf197380eb4D04, 20000);\n', '        _addPayee(0xd3092810BfC5CC9393068840450c1dBCd42038ae, 20000);\n', '        _addPayee(0xBe1706e1bA52bc5394f336810a4f72384B529ceE, 28000);\n', '        _addPayee(0x315CEA9d9c15B126a96dbaEA663B5Eb538FDd090, 28000);\n', '        _addPayee(0xCf6eb35Cb37C958E264C14F1c5D2F82FCbe87EF3, 30000);\n', '        _addPayee(0xB950B88Cad8e64977DB05f7dC5C094A14a454e73, 30000);\n', '        _addPayee(0x37393F3f845457B3a8F7799eF8dE0a911eA12AbC, 33300);\n', '        _addPayee(0x01f2f39f782228772e40446ef85f42cF775daa9b, 34211);\n', '        _addPayee(0x401977ea9118860B089E69137f031DD480039FC0, 50000);\n', '        _addPayee(0xa215F1B06e7945d331F2Df30961027123947a40D, 50000);\n', '        _addPayee(0xCb2E0C9EB7735eF639d68f39671D20Bf82128570, 50000);\n', '        _addPayee(0x07C9fC2907DF7C99E9fdD4326ed6A81BDC7C62b5, 50000);\n', '        _addPayee(0x6aF1Da708459bd988164B9fA28FAf944f2F9BaFF, 50000);\n', '        _addPayee(0x7C83c1A06514b02273De7351c3A7c85e51E3a759, 53491);\n', '        _addPayee(0x37223d721901EC493906ddF800B71dbCB347fa68, 60000);\n', '        _addPayee(0xB9883577fa54bB72764a2a85d5e46157E5694018, 70000);\n', '        _addPayee(0xCBBE17De5e61e746DCd43E8D4A072505d0747FeA, 82214);\n', '        _addPayee(0x6Fb94846cF442f0b5C4d8B8876E4DbeC80017778, 90000);\n', '        _addPayee(0x515280Dd3A3d04f97A7a257E22826fa48A2d5309, 100000);\n', '        _addPayee(0x034961ef5fD3f25dbb91440AD3CE0a119e875847, 100000);\n', '        _addPayee(0x071FCdd8F8Dbab01B864E2ABD3D53C55EDB86FB8, 100000);\n', '        _addPayee(0x887b86B6B6957F7bbeA88B8CEfD392f39236A88C, 100000);\n', '        _addPayee(0xbDd7d0D0ff36A9F333846D4a149C86b51E3407Ae, 100000);\n', '        _addPayee(0x3Da35E952dA0Cd2753d46FAE58069103D979FaFd, 100000);\n', '        _addPayee(0x70f1033420e6a50dCB9894Cb76afa5443d749d4C, 100000);\n', '        _addPayee(0x1D096f771713570F529A2db5aac1F296a3613a7e, 100000);\n', '        _addPayee(0x7fDF77E88CbE0815fe6c8F32Cc2C24D81678BD07, 100000);\n', '        _addPayee(0x8c1c4fD37bBcE8e321B3f134A0eEdAF1fB30ce65, 100000);\n', '        _addPayee(0xC0B9d32df371B4DA6b4DAa17BcfD2062f85906e3, 100000);\n', '        _addPayee(0xF6c9aB45bf3F770371B25E24503564bab8D41E63, 100000);\n', '        _addPayee(0xc2956790F439E90F018Dac98B0058a1187dcDFdD, 100000);\n', '        _addPayee(0xaAeE3Da7425Be3F13dfE50F4Fb55218431cb9A02, 100000);\n', '        _addPayee(0xbAF70FeD41a8CD27B9308204632bce9FDff9dF4f, 100000);\n', '        _addPayee(0x834385611a5eD6fD80688db085Cb658ACC43f8a6, 100000);\n', '        _addPayee(0xFDb8dfdE77cFc6a39C91371D7c74aB47f464Cb90, 100000);\n', '        _addPayee(0x19D8372e086ee6b6d1e80598b2c5B2628526c44D, 100000);\n', '        _addPayee(0x89600821B82f907B1ab472660dD150d1232318e8, 100000);\n', '        _addPayee(0x1445d5070d5298D441b891c2111F726766B5Db34, 100000);\n', '        _addPayee(0xfa050fB4E02565f810cEb2778Eb90E593D02149C, 150000);\n', '        _addPayee(0xC668693cE5312a7A64D701F7c539498dcFce48F3, 150000);\n', '        _addPayee(0xc9aB5825CEACC38a014EcC349bd3FB8572de81D4, 150000);\n', '        _addPayee(0x29F0567C20Eeb25fc6F234DEFe0C6234BFD28E72, 190000);\n', '        _addPayee(0x5FD520dcB33532EDC0E46390cEb38B2034BAa163, 193000);\n', '        _addPayee(0xB1E436ff825F116d390356f606F059DDADEc96A6, 200000);\n', '        _addPayee(0xCE8224B761fCD0a839b2E9a091C498a6537fF35d, 200000);\n', '        _addPayee(0x2815C91A4AbD5Ac22214F693b0402b1b6a56c098, 200000);\n', '        _addPayee(0x26E7709c399F866Fc4f1CC8A86120511566616A6, 200000);\n', '        _addPayee(0xEC0620979Ed8Fe8202904E02e8E69A1975c8a9BD, 200000);\n', '        _addPayee(0x941251ce526494F8dbb95C42a5320995657CD1a6, 200000);\n', '        _addPayee(0xaaBE798f769798e0aa72d6fF985688e6f001a313, 200000);\n', '        _addPayee(0x3cE77e5B6207d95d20A5B9214c072B5E241E6024, 200000);\n', '        _addPayee(0x12CEdf1cA3083Dd4Aa6384E7c16D12F1BE82fc87, 200000);\n', '        _addPayee(0x6e19d084c4fcB4D226E3D66727e86A96e741dcE1, 200000);\n', '        _addPayee(0xdc47a453457D24737F1bBE68405eE8187ca5d925, 201000);\n', '        _addPayee(0x97b004364e6135cFAE05D33A5Cd21002dd4a49B1, 246300);\n', '        _addPayee(0x185A430Af096CabcCA0710DE33713Dda7Be2aD18, 252814);\n', '        _addPayee(0x4B97B08F1f9CbaA5FaDd18Ec9cbC9135ACecd6E3, 275000);\n', '        _addPayee(0xf2C95079E35a27c296B01759431e05c38E392A21, 300000);\n', '        _addPayee(0x279d1194C9766fE2101de5a832C865936912302B, 300000);\n', '        _addPayee(0x7109e009F6D6741Bd94830bCc6b756369863a701, 300000);\n', '        _addPayee(0xCf0E9b4746cfB97bAE329FE5F696969F6564566a, 300000);\n', '        _addPayee(0x9CBBDA094cc0FA9217b783aCE7F0C103a8265cC4, 300000);\n', '        _addPayee(0x1162A2E340C3b6b845E2993eE6807aC67Ff4230C, 300000);\n', '        _addPayee(0x6eBD7c0d6D7B6bEa3F2Fd7767DC0e9992dc37Fe6, 390000);\n', '        _addPayee(0x9175417aaD501959FE397C3e880Df6a9521185E5, 400000);\n', '        _addPayee(0x5625Dc390A5bA395eDe44E3c8550302Df758541a, 400000);\n', '        _addPayee(0xc960c705300004FDF99a6c0060B5C9601EcC3E8e, 400000);\n', '        _addPayee(0x903153f55770B7668A497180F7Fa93471545Ffe2, 400000);\n', '        _addPayee(0x97aA4C1450FD768C269Ec55dF87E429922625947, 400000);\n', '        _addPayee(0x9C7B84BE5D69BB41a718A4aF921E44730a277F90, 400000);\n', '        _addPayee(0x362E5681c042f6ad8D0Ea1DCA0F4E1f12332865d, 500000);\n', '        _addPayee(0x5c56f1D66FDD70241d38e814C6d2CEA4B2A67bC4, 500000);\n', '        _addPayee(0xe40a35702D7Ba6d1047067399e586f1C9A6Ea417, 500000);\n', '        _addPayee(0x4fa8E964B1F255E2833bA75B5588955F26D7e63F, 500000);\n', '        _addPayee(0xac313Bbb81cb815b760b509D2A4f6b488B475671, 500000);\n', '        _addPayee(0xf67134B2De0cd053a9302AE4ded11E1A46e7bea6, 538618);\n', '        _addPayee(0xe3Ee6Bca8717D0bE1418f218DF3255bD9365Cc00, 600000);\n', '        _addPayee(0x8f259FDd7C9Efc9A17320aC2c5d4FE2F692451e6, 600000);\n', '        _addPayee(0xd342240C555a864CB4366031dDC6C285e3298443, 630000);\n', '        _addPayee(0xf9ac1A4A0E2A8F9C6685495f90306D52cB4D0ce9, 700000);\n', '        _addPayee(0x5984bb82F11171cb1DC2287E2A6935c44D491538, 700000);\n', '        _addPayee(0x514afF0aFCa081040D26B671b82C11bDa5F647F1, 750000);\n', '        _addPayee(0x2809ecCC4a25E3E484A270880C0E18Eff0f49dba, 800000);\n', '        _addPayee(0xd328EF6AF4a08FCcF9D47B5a0A677c6ffEa7CD52, 800000);\n', '        _addPayee(0xdcAE0361b0a3B511d8e41165575bBEbC38b92DA5, 800000);\n', '        _addPayee(0x9D221b2100CbE5F05a0d2048E2556a6Df6f9a6C3, 1000000);\n', '        _addPayee(0x7Fd18838D44A639981b90d8Fd0b172fa9848993c, 1000000);\n', '        _addPayee(0xeDd87744B9Cb0E42eFF45101dB40feA479d30E04, 1000000);\n', '        _addPayee(0xf2e9c0071998864b59b192d9aC037c24C6a31B57, 1000000);\n', '        _addPayee(0xA69ddEdDba348046d912250058e9d2C795075190, 1000000);\n', '        _addPayee(0xdd34baac32e3410B1e5c373fA8193dD506da280B, 1448621);\n', '        _addPayee(0xf68EAeBf7795D71c2144d8466E03B85fE3C88069, 1500000);\n', '        _addPayee(0x03B513b7a591b7DeA9FE61E8Ef14246D53C1426B, 2100000);\n', '        _addPayee(0x3b1356CA97A31b3a2DAd0e901b9F73380e00B66D, 3900000);\n', '        _addPayee(0xE014ba63a084feFA1720B38D20F225B259d35FFc, 6100000);\n', '        _addPayee(0xceee7adC8F403661Fc2d72471a6E20631a5B36Bf, 10000000);\n', '        _addPayee(0x723CE1691EB38384Fe4111A8694Bf85c6218a09a, 12737354);\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully\n', "     * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the\n", '     * reliability of the events, and not the actual splitting of Ether.\n', '     *\n', '     * To learn more about this see the Solidity documentation for\n', '     * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback\n', '     * functions].\n', '     */\n', '    receive () external payable virtual {\n', '        _totalReceived = _totalReceived.add(msg.value);\n', '        emit PaymentReceived(_msgSender(), msg.value, block.number);\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the total shares held by payees.\n', '     */\n', '    function totalShares() public view returns (uint256) {\n', '        return _totalShares;\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the total amount of Ether already released.\n', '     */\n', '    function totalReleased() public view returns (uint256) {\n', '        return _totalReleased;\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the amount of shares held by an account.\n', '     */\n', '    function shares(address account) public view returns (uint256) {\n', '        return _shares[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the amount of Ether already released to a payee.\n', '     */\n', '    function released(address account) public view returns (uint256) {\n', '        return _released[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Getter for the address of the payee number `index`.\n', '     */\n', '    function payee(uint256 index) public view returns (address) {\n', '        return _payees[index];\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the\n', '     * total shares and their previous withdrawals.\n', '     */\n', '    function release(address payable account) public virtual {\n', '        require(_shares[account] > 0, "PaymentSplitter: account has no shares");\n', '\n', '        uint256 totalReceived = address(this).balance.add(_totalReleased);\n', '        uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);\n', '\n', '        require(payment != 0, "PaymentSplitter: account is not due payment");\n', '\n', '        _released[account] = _released[account].add(payment);\n', '        _totalReleased = _totalReleased.add(payment);\n', '\n', '        account.transfer(payment);\n', '        emit PaymentReleased(account, payment);\n', '    }\n', '\n', '    function releaseAll() external virtual {\n', '        for (uint256 i = 0; i < _payees.length; i++) {\n', '            release(address(uint160(_payees[i])));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Add a new payee to the contract.\n', '     * @param account The address of the payee to add.\n', '     * @param shares_ The number of shares owned by the payee.\n', '     */\n', '    function _addPayee(address account, uint256 shares_) private {\n', '        require(account != address(0), "PaymentSplitter: account is the zero address");\n', '        require(shares_ > 0, "PaymentSplitter: shares are 0");\n', '        require(_shares[account] == 0, "PaymentSplitter: account already has shares");\n', '\n', '        _payees.push(account);\n', '        _shares[account] = shares_;\n', '        _totalShares = _totalShares.add(shares_);\n', '        emit PayeeAdded(account, shares_);\n', '    }\n', '\n', '    function viewTotalReceived()\n', '    external view returns (uint256) {\n', '        return _totalReceived;\n', '    }\n', '\n', '    function viewPendingPayout(address account)\n', '    external view returns (uint256) {\n', '        require(_shares[account] > 0, "PaymentSplitter: account has no shares");\n', '\n', '        uint256 totalReceived = address(this).balance.add(_totalReleased);\n', '        uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);\n', '\n', '        return payment;\n', '    }\n', '}']