#ifndef TABLE_H
#define TABLE_H

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>

#define TABLE_SIZE 200

int table_index = 0;
int current_scope = 0;

struct node_s
{
	char* lexeme;
	double value;
	int type;
	int* parameter_list; // for functions
	int array_dimension;
	int is_constant;
	int num_params;
    int scope;
	int scope_id;
	struct node_s* next;
};

typedef struct node_s node_t;

struct table_s
{
	node_t** hashtable;
	int size;
};

typedef struct table_s table_t;


table_t* create_table () {

    int size = TABLE_SIZE;
    table_t *table = (table_t*) malloc(sizeof(table_t));

    if(table) {
        table->hashtable = (node_t**) malloc(sizeof(node_t*) * size);
        if(table->hashtable) {
            table->size = size;
            for (int i = 0; i < table->size; i++) {
                table->hashtable[i] = NULL;
            }
        }
    }
    return table;
}

node_t* create_node(char* lexeme, double value, int type, int scope, int id) {
    node_t* node = (node_t*) malloc(sizeof(node_t));
    
    if(node) {
        node->lexeme = strdup(lexeme);
	    node->type = type;
	    node->value = value;
	    node->parameter_list = NULL;
	    node->array_dimension = -1;
	    node->is_constant = 0;
	    node->num_params = 0;
        node->scope = scope;
        node->next = NULL; 
		node->scope_id = id;
    }
    return node;
}

uint32_t hash( char *lexeme )
{
    size_t i;
    uint32_t hash;
    for ( hash = i = 0; i < strlen(lexeme); ++i ) {
        hash += lexeme[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }
    hash += ( hash << 3 );
    hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

    return hash % TABLE_SIZE;
}

node_t* find(table_t* table, char* lexeme)
{
	uint32_t idx = 0;
	node_t* iterator;
    
    idx = hash(lexeme);
	iterator = table->hashtable[idx];
	
	while(iterator != NULL && strcmp( lexeme, iterator->lexeme ) != 0)
	{
		iterator = iterator->next;
	}

	if(iterator == NULL) return NULL;
	return iterator;
}

node_t* findall(table_t* table, char* lexeme, int scope) {
	uint32_t idx = 0;
	node_t* iterator;
    
    idx = hash(lexeme);
	iterator = table->hashtable[idx];
	
	while(iterator != NULL)
	{
		if(strcmp( lexeme, iterator->lexeme ) == 0 && iterator->scope == scope) {
			return iterator;
		}
		iterator = iterator->next;
		
	}

	return NULL;
}

node_t* findallless(table_t* table, char* lexeme, int scope) {
	uint32_t idx = 0;
	node_t* iterator;
    
    idx = hash(lexeme);
	iterator = table->hashtable[idx];
	
	while(iterator != NULL)
	{
		if(strcmp( lexeme, iterator->lexeme ) == 0 && iterator->scope <= scope) {
			return iterator;
		}
		iterator = iterator->next;
		
	}

	return NULL;
}

node_t* insert(table_t *table, char* lexeme, double value, int type, int scoped, int id) {

    uint32_t idx;

	idx = hash(lexeme);
    node_t* entry = create_node(lexeme, value, type, scoped, id);
    node_t* head = NULL;

	if(!entry)
	{
		printf("Error: Hash table insert failed.");
		exit(1);
	}

    head = table->hashtable[idx];

	if(head == NULL)
	{
		table->hashtable[idx] = entry;
	}
	else
	{
		entry->next = table->hashtable[idx];
        table->hashtable[idx] = entry;
	}

    return entry;
}

int cpl(node_t* entry, int* list, int m)
{
	if(!entry) return -1;
	int* parameter_list = entry->parameter_list;

	if(m != entry->num_params)
	{
		printf("Number of parameters and arguments do not match");
	}

	int i;
	for(i=0; i<m; i++)
	{
		if(list[i] != parameter_list[i])
		printf("Parameter and argument types do not match");
	}

	return 1;
}

void fpl(node_t* entry, int* list, int n)
{
	if(!entry) return;
	entry->parameter_list = (int *)malloc(n*sizeof(int));

	int i;
	for(i=0; i<n; i++)
	{
		entry->parameter_list[i] = list[i];
	}
	entry->num_params = n;
}

void display_table(table_t* table) {
    int i, j;
    node_t* iterator;
    printf("\n---------------------------------------------------------------------------------------------------------------------------------------\n");
    printf("| %-20s | %-5s | %-10s | %-10s | %-7s | %-64s |\n", "Lexeme", "Scope", "Datatype", "isKT?", "nParams", "Parameter List");
    printf(  "---------------------------------------------------------------------------------------------------------------------------------------\n");

    for(i = 0; i < table->size; i++)
    {
        iterator = table->hashtable[i];

        while( iterator != NULL)
        {
            printf("| %-20s | %5d | %10d | %10d | %7d |", iterator->lexeme, iterator->scope, iterator->type, iterator->is_constant, iterator->num_params);
			for (j = 0; j < iterator->num_params; j++) {
				printf (" %3d, ", iterator->parameter_list[j]);
			}
			for (j = 0; j <= 10-iterator->num_params; j++) {
				printf ("      ");
			}
			printf("|\n");
            iterator = iterator->next;
            
        }
    }
    printf("---------------------------------------------------------------------------------------------------------------------------------------\n");
}

void display(table_t* table, char* name) {
    printf("\n---------------------------------------------------------------------------------------------------------------------------------------\n");
    printf("| %-131s |", name);
    display_table(table);
}

#endif
