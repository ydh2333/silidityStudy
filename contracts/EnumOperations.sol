//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnumOperations {
    enum OrderStatus {
        Created,
        Paid,
        Shipped,
        Delivered,
        Cancelled
    }
    
    OrderStatus public status;
    
    // 设置状态
    function createOrder() public {
        status = OrderStatus.Created;
    }
    
    function payOrder() public {
        require(status == OrderStatus.Created, "Order not created");
        status = OrderStatus.Paid;
    }
    
    function shipOrder() public {
        require(status == OrderStatus.Paid, "Order not paid");
        status = OrderStatus.Shipped;
    }
    
    // 检查状态
    function isPaid() public view returns (bool) {
        return status == OrderStatus.Paid;
    }
    
    // 枚举转整数
    function getStatusAsUint() public view returns (uint) {
        return uint(status);
    }
    
    // 整数转枚举（需要检查范围）
    function setStatusFromUint(uint _status) public {
        require(_status <= uint(OrderStatus.Cancelled), "Invalid status");
        status = OrderStatus(_status);
    }


}