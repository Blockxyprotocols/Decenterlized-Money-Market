// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

abstract contract Adminable {

    address payable public admin;
    address payable public pendingAdmin;
    address public developer;

    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    event NewAdmin(address oldAdmin, address newAdmin);

    constructor() {
        developer = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "caller must be admin");
        _;
    }

    modifier onlyAdminOrDeveloper() {
        require(msg.sender == admin || msg.sender == developer, "caller must be admin or developer");
        _;
    }

    function setPendingAdmin(address payable newPendingAdmin) external onlyAdmin {
        require(newPendingAdmin != address(0), "new pending admin cannot be the zero address");
        // Save current value, if any, for inclusion in log
        address oldPendingAdmin = pendingAdmin;
        // Store pendingAdmin with value newPendingAdmin
        pendingAdmin = newPendingAdmin;
        // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
    }

    function acceptAdmin() external {
        require(msg.sender == pendingAdmin, "only pendingAdmin can accept admin");
        // Save current values for inclusion in log
        address oldAdmin = admin;
        address oldPendingAdmin = pendingAdmin;
        // Store admin with value pendingAdmin
        admin = pendingAdmin;
        // Clear the pending value
        pendingAdmin = payable(address(0));
        emit NewAdmin(oldAdmin, admin);
        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
    }

    function checkAdmin() public view {
        require(msg.sender == admin, "caller must be admin");
    }
}
