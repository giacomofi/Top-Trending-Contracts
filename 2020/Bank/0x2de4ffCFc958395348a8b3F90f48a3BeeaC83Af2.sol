['pragma solidity ^0.6.1;\n', '\n', 'contract Owned {\n', '    constructor() public { owner = msg.sender; }\n', '    address payable public owner;\n', '\n', '    modifier onlyOwner {\n', '        require(\n', '            msg.sender == owner,\n', '            "Only owner can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * Allow the owner of this contract to transfer ownership to another address\n', '    * @param newOwner The address of the new owner\n', '    */\n', '    function transferOwnership(address payable newOwner) external onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n']
['pragma solidity ^0.6.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./Swap.sol";\n', '\n', '// solium-disable security/no-call-value\n', 'contract EtherSwap is Swap {\n', '    enum OrderState { HasFundingBalance, Claimed, Refunded }\n', '\n', '    struct FundDetails {\n', '        bytes16 orderUUID;\n', '        bytes32 paymentHash;\n', '    }\n', '    struct FundDetailsWithAdminRefundEnabled {\n', '        bytes16 orderUUID;\n', '        bytes32 paymentHash;\n', '        bytes32 refundHash;\n', '    }\n', '    struct ClaimDetails {\n', '        bytes16 orderUUID;\n', '        bytes32 paymentPreimage;\n', '    }\n', '    struct AdminRefundDetails {\n', '        bytes16 orderUUID;\n', '        bytes32 refundPreimage;\n', '    }\n', '    struct SwapOrder {\n', '        address payable user;\n', '        bytes32 paymentHash;\n', '        bytes32 refundHash;\n', '        uint256 onchainAmount;\n', '        uint256 refundBlockHeight;\n', '        OrderState state;\n', '        bool exist;\n', '    }\n', '\n', '    mapping(bytes16 => SwapOrder) orders;\n', '\n', '    event OrderFundingReceived(\n', '        bytes16 orderUUID,\n', '        uint256 onchainAmount,\n', '        bytes32 paymentHash,\n', '        uint256 refundBlockHeight\n', '    );\n', '    event OrderFundingReceivedWithAdminRefundEnabled(\n', '        bytes16 orderUUID,\n', '        uint256 onchainAmount,\n', '        bytes32 paymentHash,\n', '        uint256 refundBlockHeight,\n', '        bytes32 refundHash\n', '    );\n', '    event OrderClaimed(bytes16 orderUUID);\n', '    event OrderRefunded(bytes16 orderUUID);\n', '    event OrderAdminRefunded(bytes16 orderUUID);\n', '\n', '    /**\n', '     * Delete the order data that is no longer necessary after a swap is claimed or refunded.\n', '     */\n', '    function deleteUnnecessaryOrderData(SwapOrder storage order) internal {\n', '        delete order.user;\n', '        delete order.paymentHash;\n', '        delete order.onchainAmount;\n', '        delete order.refundBlockHeight;\n', '    }\n', '\n', '    /**\n', '     * Allow the sender to fund a swap in one or more transactions.\n', '     */\n', '    function fund(FundDetails memory details) public payable {\n', '        SwapOrder storage order = orders[details.orderUUID];\n', '\n', '        if (!order.exist) {\n', '            order.user = msg.sender;\n', '            order.exist = true;\n', '            order.paymentHash = details.paymentHash;\n', '            order.refundBlockHeight = block.number + refundDelay;\n', '            order.state = OrderState.HasFundingBalance;\n', '        } else {\n', '            require(order.state == OrderState.HasFundingBalance, "Order already claimed or refunded.");\n', '        }\n', '        order.onchainAmount += msg.value;\n', '\n', '        emit OrderFundingReceived(details.orderUUID, order.onchainAmount, order.paymentHash, order.refundBlockHeight);\n', '    }\n', '\n', '    /**\n', '     * Allow the sender to fund a swap in one or more transactions and provide a refund\n', '     * hash, which can enable faster refunds if the refund preimage is supplied by the\n', "     * counterparty once it's decided that a claim transaction will not be submitted.\n", '     */\n', '    function fundWithAdminRefundEnabled(FundDetailsWithAdminRefundEnabled memory details) public payable {\n', '        SwapOrder storage order = orders[details.orderUUID];\n', '\n', '        if (!order.exist) {\n', '            order.user = msg.sender;\n', '            order.exist = true;\n', '            order.paymentHash = details.paymentHash;\n', '            order.refundHash = details.refundHash;\n', '            order.refundBlockHeight = block.number + refundDelay;\n', '            order.state = OrderState.HasFundingBalance;\n', '        } else {\n', '            require(order.state == OrderState.HasFundingBalance, "Order already claimed or refunded.");\n', '        }\n', '        order.onchainAmount += msg.value;\n', '\n', '        emit OrderFundingReceivedWithAdminRefundEnabled(\n', '            details.orderUUID,\n', '            order.onchainAmount,\n', '            order.paymentHash,\n', '            order.refundBlockHeight,\n', '            order.refundHash\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Allow the recipient to claim the funds once they know the preimage of the hashlock.\n', '     * Anyone can claim, but the tokens will always be sent to the owner.\n', '     */\n', '    function claim(ClaimDetails memory details) public {\n', '        SwapOrder storage order = orders[details.orderUUID];\n', '\n', '        require(order.exist == true, "Order does not exist.");\n', '        require(order.state == OrderState.HasFundingBalance, "Order not in claimable state.");\n', '        require(sha256(abi.encodePacked(details.paymentPreimage)) == order.paymentHash, "Incorrect payment preimage.");\n', '        require(block.number <= order.refundBlockHeight, "Too late to claim.");\n', '\n', '        order.state = OrderState.Claimed;\n', '\n', '        (bool success, ) = owner.call.value(order.onchainAmount)("");\n', '        require(success, "Transfer failed.");\n', '\n', '        deleteUnnecessaryOrderData(order);\n', '        emit OrderClaimed(details.orderUUID);\n', '    }\n', '\n', '    /**\n', '     * Refund the sent amount back to the funder if the timelock has expired.\n', '     */\n', '    function refund(bytes16 orderUUID) public {\n', '        SwapOrder storage order = orders[orderUUID];\n', '\n', '        require(order.exist == true, "Order does not exist.");\n', '        require(order.state == OrderState.HasFundingBalance, "Order not in refundable state.");\n', '        require(block.number > order.refundBlockHeight, "Too early to refund.");\n', '\n', '        order.state = OrderState.Refunded;\n', '\n', '        (bool success, ) = order.user.call.value(order.onchainAmount)("");\n', '        require(success, "Transfer failed.");\n', '\n', '        deleteUnnecessaryOrderData(order);\n', '        emit OrderRefunded(orderUUID);\n', '    }\n', '\n', '    /**\n', '     * Refund the sent amount back to the funder if a valid refund preimage is supplied.\n', '     * This provides a better UX than a timelocked refund. It is entirely at the discretion\n', '     * of the counterparty (claimer) as to whether the refund preimage will be provided to\n', "     * the funder, but is recommended once it's decided that a claim transaction will not\n", '     * be submitted.\n', '     */\n', '    function adminRefund(AdminRefundDetails memory details) public {\n', '        SwapOrder storage order = orders[details.orderUUID];\n', '\n', '        require(order.exist == true, "Order does not exist.");\n', '        require(order.state == OrderState.HasFundingBalance, "Order not in refundable state.");\n', '        require(order.refundHash != 0, "Admin refund not allowed.");\n', '        require(sha256(abi.encodePacked(details.refundPreimage)) == order.refundHash, "Incorrect refund preimage.");\n', '\n', '        order.state = OrderState.Refunded;\n', '\n', '        (bool success, ) = order.user.call.value(order.onchainAmount)("");\n', '        require(success, "Transfer failed.");\n', '\n', '        deleteUnnecessaryOrderData(order);\n', '        emit OrderAdminRefunded(details.orderUUID);\n', '    }\n', '}\n']
['pragma solidity ^0.6.1;\n', '\n', 'import "./Owned.sol";\n', '\n', 'contract Swap is Owned {\n', '    // Refund delay. Default: 4 hours\n', '    uint public refundDelay = 4 * 60 * 4;\n', '\n', '    // Max possible refund delay: 5 days\n', '    uint constant MAX_REFUND_DELAY = 60 * 60 * 2 * 4;\n', '\n', '    /**\n', '     * Set the block height at which a refund will successfully process.\n', '     */\n', '    function setRefundDelay(uint delay) external onlyOwner {\n', '        require(delay <= MAX_REFUND_DELAY, "Delay is too large.");\n', '        refundDelay = delay;\n', '    }\n', '}\n']
