module analyze_semantics;

import structures;
import symbol_table;
import semantic_errors;
import std.stdio: writeln;


void semantic_analysis(Program* program, ref SymbolTable table) {
    int count_main = 0;
    foreach(Function* func; program.functions) {
        if(table.is_program_entry_point(func.name)) {
            count_main++;
        }
        analyze(func, table);
    }
    if(count_main != 1) {
        missing_main();
    }
}

void analyze(Function* func, ref SymbolTable table) {
    add_func_args_to_local_variable_table(func, table);
    check_for_order_of_statements(func.stmts);
    match_existing_scoped_variables(func.stmts, table);
}

void add_func_args_to_local_variable_table(Function* func, ref SymbolTable table) {
    string[] func_args = func.arg_names.dup;
    string[] arg_types = table.get_function_args(func.name);
    if(func_args.length != arg_types.length) {
        throw new Exception("Number of function variables is not the 
                            same as number of types for same function.");
    }
    for(int i = 0; i < func_args.length; i++) {
        table.add_local_variable(func_args[i], arg_types[i]);
    }
}

void check_for_order_of_statements(Statement*[] statements) {
    for(int i = 0; i < statements.length; i++) {
        switch(statements[i].stmt_type) {
            case StatementTypes.else_statement:
            case StatementTypes.else_if_statement:
                halt_if_orphaned_else(statements, i);
                break;
            case StatementTypes.break_statement:
            case StatementTypes.continue_statement:
                if(i < statements.length-1) {
                    loop_logic_creating_dead_code();
                }
                break;
            case StatementTypes.return_statement:
                check_return_statement(statements, i);
                break; 
            default:
                check_for_order_of_statements(statements[i].stmts);  
                break;
        }
    }
}

void halt_if_orphaned_else(Statement*[] statements, int index) {
    if(index == 0) {
        orphaned_else_statement();
    }
    if(statements[index-1].stmt_type != StatementTypes.if_statement) {
        orphaned_else_statement();
    }
    if(statements[index-1].stmt_type != StatementTypes.else_if_statement) {
        orphaned_else_statement();
    }
}

void check_return_statement(Statement*[] statements, int index) {
    if(index < statements.length-1) {
        return_creating_dead_code();
    } else if(statements[index].stmts.length > 0) {
        check_for_order_of_statements(statements[index].stmts);
    }
}

void match_existing_scoped_variables(Statement*[] statements, ref SymbolTable table) {
        return;
}