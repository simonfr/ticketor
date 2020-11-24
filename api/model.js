function fromOdoo(expense) {
    return {
        id: expense.id,
        name: expense.name,
        date: expense.date,
        unit_amount: expense.unit_amount,
        quantity: expense.quantity,
        total_amount: expense.total_amount,
        create_date: expense.create_date,
        state: expense.state
    }
}

function toOdoo(expense) {
    return{
        id: expense.id,
        name: expense.name,
        date: expense.date,
        unit_amount: expense.unit_amount,
        quantity: expense.quantity,
        total_amount: expense.total_amount,
        create_date: expense.create_date,
        state: expense.state
    }
}

module.exports =  {
    fromOdoo: fromOdoo,
    toOdoo: toOdoo
}